defmodule EventSerializer.Decoder do
  @moduledoc """
  This module is resposible to decode the messages from a Kafka topic.
  """

  alias EventSerializer.Helpers.MapBuilder

  @doc """
  This function decodes the message from a Kafka topic. First we get the `schema_id`
  in the message so we can fetch the schema which will be already cached
  by the `EventSerializer.SchemaRegistryCache`.
  """
  def call(<<_magic_bytes::bytes-size(1), schema_id::size(32), payload::binary>>) do
    decoder = avlizer_confluent().make_decoder(schema_id)
    decoded_message = avlizer_confluent().decode(decoder, payload)

    mapped_message = MapBuilder.to_map(decoded_message)

    {:ok, mapped_message}
  end

  def call(_) do
    {:error, :invalid_binary}
  end

  defp avlizer_confluent, do: EventSerializer.Config.avlizer_confluent
end
