defmodule EventSerializer.SchemaRegistryCacheTest do
  use ExUnit.Case, async: false

  alias EventSerializer.SchemaRegistryCache, as: Subject

  setup do
    topic_names = Application.get_env(:event_serializer, :topic_names)

    Application.put_env(:event_serializer, :topic_names, ["known-topic-1", "known-topic-2"])

    Subject.start_link()

    on_exit(fn ->
      Application.put_env(:event_serializer, :topic_names, topic_names)
      System.delete_env("SYSTEM_CONFIG_1")
      System.delete_env("SYSTEM_CONFIG_2")
    end)

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

  @tag :this
  describe "fetch_schema/0 with confex style configuration tuples" do
    setup do
      topic_names = Application.get_env(:event_serializer, :topic_names)

      System.put_env([
        {"SYSTEM_CONFIG_1", "confex-topic-1"},
        {"SYSTEM_CONFIG_2", "confex-topic-2"}
      ])

      Application.put_env(:event_serializer, :topic_names, [
        {:system, "SYSTEM_CONFIG_1"},
        {:system, "SYSTEM_CONFIG_2", "default"}
      ])

      on_exit(fn ->
        Application.put_env(:event_serializer, :topic_names, topic_names)
      end)

      Subject.start_link()

      :ok
    end

    test "it returns correct map when the Schema Registry does respond" do
      expected_result = [
        %{id: 3, name: "confex-topic-1-key"},
        %{id: 3, name: "confex-topic-1-value"},
        %{id: 4, name: "confex-topic-2-key"},
        %{id: 4, name: "confex-topic-2-value"}
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
