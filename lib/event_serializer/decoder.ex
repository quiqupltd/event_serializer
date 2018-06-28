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
  def call(event) do
    <<magic_bytes::bytes-size(4), schema_id::bytes-size(1), payload::binary>> = event
    <<parsed_schema_id::utf8>> = schema_id

    decoder = :avlizer_confluent.make_decoder(parsed_schema_id)
    decoded_message = :avlizer_confluent.decode(decoder, payload)

    mapped_message = MapBuilder.to_map(decoded_message)

    {:ok, mapped_message}
  end
end
