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
    case try_decode(decoder, payload) do
      {:ok, decoded_message} ->
        mapped_message = MapBuilder.to_map(decoded_message)
        {:ok, mapped_message}
      {:error, error} ->
        {:error, error}
    end
  end

  def call(_) do
    {:error, :invalid_binary}
  end

  def try_decode(decoder, payload) do
    try do
      {:ok, avlizer_confluent().decode(decoder, payload)}
    rescue
      error in MatchError ->
        {:error, "avlizer decode error " <> inspect(error)}
    end
  end

  defp avlizer_confluent, do: EventSerializer.Config.avlizer_confluent
end
