defmodule EventSerializer.TestSupport.Mocks.AvlizerConfluentMock do
  # matches when the schema is found and returned via CourierActivityMock
  def make_encoder(1), do: "encoder"
  # :avlizer_confluent.encode(encoder, [{"id", 123}]) # => <<246, 1>>
  def encode("encoder", _payload), do: <<246, 1>>
end
