defmodule EventSerializer.ConfigTest do
  use ExUnit.Case, async: false

  alias EventSerializer.Config, as: Subject

  def setup_all do
    default = Application.get_env(:event_serializer, :topic_names)
    on_exit(fn -> Application.put_env(:event_serializer, :topic_names, default) end)
  end

  describe "topic_names/0" do
    test "it returns nil when topic_names is not set" do
      Application.delete_env(:event_serializer, :topic_names)

      result = Subject.topic_names

      refute result
    end

    test "it returns a simple list" do
      expected = random_topic_names()

      Application.put_env(:event_serializer, :topic_names, expected)
      result = Subject.topic_names

      assert result == expected
    end

    test "it parses a CSV list" do
      expected = random_topic_names()
      csv = Enum.join(expected, ",")

      Application.put_env(:event_serializer, :topic_names, csv)
      result = Subject.topic_names

      assert result == expected
    end

    test "it applies a function with arguments specified by a tuple" do
      expected = static_topic_names()
      fun = {__MODULE__, :get_topic_names, [true]}
      
      Application.put_env(:event_serializer, :topic_names, fun)
      result = Subject.topic_names

      assert result == expected
    end

    test "it directly applies a function of arity 0" do
      expected = static_topic_names()
      
      Application.put_env(:event_serializer, :topic_names, &static_topic_names/0)
      result = Subject.topic_names

      assert result == expected
    end
  end

  def get_topic_names(static \\ false) do
    if static, do: static_topic_names(), else: random_topic_names()
  end

  def static_topic_names do
    [
      "static.topic.one",
      "static.topic.two",
      "static.topic.three"
    ]
  end

  defp random_topic_names do
    Enum.map(1..3, fn _ -> random_string(10) end)
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end