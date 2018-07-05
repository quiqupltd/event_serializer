defmodule EventSerializer.Encoder do
  @moduledoc """
  This module is resposible to encode the message sent to a Kafka topic.
  """

  @doc """
  Elixir's erlavro library don't put some bytes used by Confluent for the Schema Registry.
  So, in order to publish using AVRO properly, both the key and values, after being
  encoded to avro must be prepended with the bytes expected by confluent:

    <<0>> <> <<schema_id :: size(32)>> <> encoded_key_by_erlavro
    <<0>> <> <<schema_id :: size(32)>> <> encoded_message_by_erlavro

  This function uses the `avlizer_confluent` from erlang to encode the schema.

  The `make_encoder` makes a request to download the schema with the given `schema_id`
  and result is cached by this library. The first request to download the schema is made by
  a gen_server `EventSerializer.SchemaRegistryCache` which is initialized before the app starts.

  The second step will encode the message into a binary format:

  <<0, 0, 0, 0, 13, 142, 229, 41, 48, 50, 48, 49, 56, 45 ....>>

  Then we prepend the `schema_id` in message.
  """
  def call(schema_name, event) do
    schema_id = schema_registry().fetch(schema_name)

    encoder = avlizer_confluent().make_encoder(schema_id)
    bindata = avlizer_confluent().encode(encoder, event)

    {:ok, IO.iodata_to_binary(<<0>> <> <<schema_id::size(32)>> <> bindata)}
  end

  defp schema_registry do
    EnvConfig.get(:event_serializer, :schema_registry)
  end

  defp avlizer_confluent do
    EnvConfig.get(:event_serializer, :avlizer_confluent)
  end
end
