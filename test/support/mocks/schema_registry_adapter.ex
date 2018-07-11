defmodule EventSerializer.TestSupport.Mocks.SchemaRegistryAdapterMock do
  def schema_id_for("known-topic-key"), do: 1
  def schema_id_for("known-topic-value"), do: 1
  def schema_id_for(unknown_topic), do: {:error, unknown_topic}
end
