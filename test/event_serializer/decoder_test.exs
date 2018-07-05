defmodule EventSerializer.DecoderTest do
  use ExUnit.Case, async: true

  alias EventSerializer.Decoder, as: Subject

  setup do
    event = <<0, 0, 0, 0, 1, 246, 1>>

    %{event: event}
  end

  describe "call/1" do
    test "it decodes the payload correctly", %{event: event} do
      {:ok, mapped_message} = Subject.call(event)

      assert mapped_message == "decoded_message"
    end

    test "with an invalid byte array it returns an error" do
      assert {:error, :invalid_binary} = Subject.call("")
    end
  end
end
