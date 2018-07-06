defmodule EventSerializer.Config do
  def topic_name do
    EnvConfig.get(:event_serializer, :topic_name)
  end

  def schema_registry_url do
    EnvConfig.get(:event_serializer, :schema_registry_url)
  end

  def enabled? do
    enabled(EnvConfig.get(:event_serializer, :enabled))
  end

  def avlizer_confluent do
    EnvConfig.get(:event_serializer, :avlizer_confluent, :avlizer_confluent)
  end

  def schema_registry_adapter do
    EnvConfig.get(:event_serializer, :schema_registry_adapter, EventSerializer.SchemaRegistryAdapter)
  end

  def schema_registry do
    EnvConfig.get(:event_serializer, :schema_registry, EventSerializer.SchemaRegistryCache)
  end

  defp enabled(true), do: true
  defp enabled(_), do: false
end
