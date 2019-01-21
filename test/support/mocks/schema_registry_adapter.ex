defmodule EventSerializer.TestSupport.Mocks.SchemaRegistryAdapterMock do
  def schema_id_for("known-topic-1-key"), do: 1
  def schema_id_for("known-topic-1-value"), do: 1
  def schema_id_for("known-topic-2-key"), do: 2
  def schema_id_for("known-topic-2-value"), do: 2
  def schema_id_for("confex-topic-1-key"), do: 3
  def schema_id_for("confex-topic-1-value"), do: 3
  def schema_id_for("confex-topic-2-key"), do: 4
  def schema_id_for("confex-topic-2-value"), do: 4

  def schema_id_for(unknown_topic), do: {:error, unknown_topic}
end
