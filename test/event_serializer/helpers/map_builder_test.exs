defmodule EventSerializer.Helpers.MapBuilderTest do
  use ExUnit.Case, async: true

  alias EventSerializer.Helpers.MapBuilder

  describe "to_map/1" do
    test "converts the list of tuple formats to an Elixir map" do
      payload = [
        {"a",
         [
           {"b", "c"}
         ]},
        {"list_of_lists",
         [
           [{"a", "b"}, {"c", "d"}],
           [{"a", "b"}, {"c", "d"}]
         ]}
      ]

      expected = %{
        "a" => %{
          "b" => "c"
        },
        "list_of_lists" => [%{"a" => "b", "c" => "d"}, %{"a" => "b", "c" => "d"}]
      }

      assert MapBuilder.to_map(payload) == expected
    end
  end
end
