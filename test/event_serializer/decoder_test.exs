defmodule EventSerializer.DecoderTest do
  use ExUnit.Case, async: true

  alias EventSerializer.Decoder, as: Subject

  describe "call/1" do
    test "it decodes the payload correctly with a low schema_id number" do
      event = <<0, 0, 0, 0, 1, 246, 1>>
      {:ok, mapped_message} = Subject.call(event)

      assert mapped_message == <<246, 1>>
    end

    test "it decodes the payload correctly with a large schema_id number" do
      event = <<0, 0, 0, 1, 169, 138, 172, 161, 1, 48, 50>>
      {:ok, mapped_message} = Subject.call(event)

      assert mapped_message == <<138, 172, 161, 1, 48, 50>>
    end

    test "with an invalid byte array it returns an error" do
      assert {:error, :invalid_binary} = Subject.call("")
    end

    test "it errors the payload correctly with a low schema_id number" do
      event = <<0, 0, 0, 0, 1, 246, 1, 2>>
      assert {:error, "avlizer decode error %MatchError{term: nil}"} = Subject.call(event)
    end
  end
end
