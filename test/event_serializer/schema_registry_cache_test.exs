defmodule EventSerializer.SchemaRegistryCacheTest do
  use ExUnit.Case, async: true

  alias EventSerializer.SchemaRegistryCache, as: Subject

  setup do
    topic_names = Application.get_env(:event_serializer, :topic_names)
    Application.put_env(:event_serializer, :topic_names, ["known-topic-1", "known-topic-2"])

    on_exit(fn ->
      Application.put_env(:event_serializer, :topic_names, topic_names)
    end)

    Subject.start_link()

    :ok
  end

  describe "fetch_schemas/0" do
    test "it returns an empty array when the Schema Registry does not respond" do
      Application.put_env(:event_serializer, :topic_names, ["unknown-topic"])

      assert [] == Subject.fetch_schemas()
    end

    test "it returns correct map when the Schema Registry does respond" do
      expected_result = [
        %{id: 1, name: "known-topic-1-key"},
        %{id: 1, name: "known-topic-1-value"},
        %{id: 2, name: "known-topic-2-key"},
        %{id: 2, name: "known-topic-2-value"}
      ]

      assert Subject.fetch_schemas() == expected_result
    end
  end

  describe "fetch/1" do
    test "when the schema is found it returns the schema id" do
      assert Subject.fetch("known-topic-1-key") == 1
    end

    test "when the schema is not found it returns the schema id" do
      assert Subject.fetch("unknown-topic-key") == nil
    end
  end
end
