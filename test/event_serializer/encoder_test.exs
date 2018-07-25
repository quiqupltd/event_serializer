defmodule EventSerializer.EncoderTest do
  use ExUnit.Case, async: true

  alias EventSerializer.Encoder, as: Subject

  describe "call/1" do
    test "when the schema is found it encodes the payload correctly" do
      {:ok, value} = Subject.call("found_schema", "valid_payload")

      assert <<0, 0, 0, 0, 1, 246, 1>> = value
    end

    test "when the schema is not found returns :error" do
      assert {:error, "No matching schema found"} = Subject.call("not_found_schema", "valid_payload")
    end

    test "when the payload does not convert" do
      assert {:error, "avlizer encode error %ErlangError{original: nil}"} = Subject.call("found_schema", "bad_payload")
    end
  end
end

