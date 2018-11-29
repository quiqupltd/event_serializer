defmodule EventSerializer.Config do
  @moduledoc """
  Helpers for getting config
  """

  def topic_names do
    :event_serializer |> EnvConfig.get(:topic_names) |> not_nil_topic_names
  end

  defp not_nil_topic_names(nil), do: []
  defp not_nil_topic_names(topic_names), do: topic_names

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
    EnvConfig.get(
      :event_serializer,
      :schema_registry_adapter,
      EventSerializer.SchemaRegistryAdapter
    )
  end

  def schema_registry do
    EnvConfig.get(:event_serializer, :schema_registry, EventSerializer.SchemaRegistryCache)
  end

  defp enabled(false), do: false
  defp enabled(_), do: true
end
