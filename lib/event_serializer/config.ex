defmodule EventSerializer.Config do
  @moduledoc """
  Helpers for getting config
  """

  def topic_names do
    :event_serializer
    |> EnvConfig.get(:topic_names)
    |> topic_names()
  end

  defp topic_names(nil), do: nil
  defp topic_names(list) when is_list(list), do: list

  defp topic_names(csv) when is_binary(csv) do
    String.split(csv, ",", trim: true) |> Enum.map(&String.trim/1)
  end

  defp topic_names({mod, fun, args}) when is_atom(mod) and is_atom(fun) do
    apply(mod, fun, args)
  end

  defp topic_names(fun) when is_function(fun, 0) do
    fun.()
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
