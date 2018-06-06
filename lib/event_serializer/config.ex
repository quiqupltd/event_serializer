defmodule EventSerializer.Config do
  def topic_name do
    Application.get_env(:event_serializer, :topic_name)
  end

  def schema_registry_url do
    Application.get_env(:event_serializer, :schema_registry_url)
  end
end
