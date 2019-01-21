defmodule EventSerializer.TestSupport.Mocks.AvlizerConfluentMock do
  # matches when the schema is found and returned via SchemaRegistryMock
  def make_encoder(_known_schema_id = 1), do: "encoder"
  def make_encoder(_known_schema_id = 2), do: "encoder"
  def make_encoder(_known_schema_id = 3), do: "encoder"
  def make_encoder(_known_schema_id = 4), do: "encoder"
  # :avlizer_confluent.encode(encoder, [{"id", 123}]) # => <<246, 1>>
  def encode("encoder", "valid_payload"), do: <<246, 1>>
  def encode("encoder", "bad_payload"), do: raise(ErlangError)

  # matches raw kafka payload when the encoded byte has version 1 schema
  # eg <<0, 0, 0, 0, 1, ...
  def make_decoder(_schema_id = 1), do: "decoder1"
  def make_decoder(_schema_id = 425), do: "decoder2"
  # default the matching decoder to return a known message
  def decode("decoder1", <<246, 1>>), do: <<246, 1>>
  def decode("decoder2", payload), do: payload
  def decode("decoder1", <<246, 1, 2>>), do: raise(MatchError)
end
