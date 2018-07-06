defmodule EventSerializer.TestSupport.Mocks.AvlizerConfluentMock do
  # matches when the schema is found and returned via CourierActivityMock
  def make_encoder(_known_schema_id = 1), do: "encoder"
  # :avlizer_confluent.encode(encoder, [{"id", 123}]) # => <<246, 1>>
  def encode("encoder", _payload), do: <<246, 1>>

  # matches raw kafka payload when the encoded byte has version 1 schema
  # eg <<0, 0, 0, 0, 1, ...
  def make_decoder(_schema_id = 1), do: "decoder"
  # default the matching decoder to return a known message
  def decode("decoder", _payload), do: "decoded_message"
end
