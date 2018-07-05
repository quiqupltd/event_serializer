defmodule EventSerializer.EncoderTest do
  use ExUnit.Case, async: true

  alias EventSerializer.Encoder, as: Subject

  setup do
    key = [{"id", 123}]

    %{key: key}
  end

  describe "call/1" do
    test "when the schema is found it encodes the payload correctly", %{ key: key } do
      {:ok, value} = Subject.call("found_schema", key)

      assert <<0, 0, 0, 0, 1, 246, 1>> = value
    end
  end
end

