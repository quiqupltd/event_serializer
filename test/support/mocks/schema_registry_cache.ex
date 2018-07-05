defmodule EventSerializer.TestSupport.Mocks.CourierActivityMock do
  def fetch("found_schema"), do: 1
  def fetch(_), do: nil
end
