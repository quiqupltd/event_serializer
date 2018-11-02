defmodule EventSerializer.SchemaRegistryAdapter do
  @moduledoc """
  This module is resposible to fetch the schemas from the schema registry.
  """
  use Tesla

  alias EventSerializer.Config

  plug(Tesla.Middleware.Headers, [{"Content-Type", "application/json"}])
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger)

  def schema_for(name), do: name |> fetch_schema("schema")
  def schema_id_for(name), do: name |> fetch_schema("id")

  defp fetch_schema(name, attribute) do
    name
    |> url()
    |> get()
    |> parse_response()
    |> extract_response(attribute)
  end

  defp parse_response({:ok, response}), do: response.body |> Poison.decode!()
  defp parse_response({:error, error}), do: {:error, error}

  defp extract_response({:error, reason}, _attribute), do: {:error, reason}
  defp extract_response(nil, _attribute), do: {:error, "nothing returned"}

  defp extract_response(%{"error_code" => _error_code, "message" => message}, _attribute) do
    {:error, message}
  end

  defp extract_response(%{"id" => _id, "schema" => _schema} = map, attribute) do
    map |> Map.fetch!(attribute)
  end

  defp url(name), do: "#{base_url()}/subjects/#{name}/versions/latest"

  defp base_url, do: Config.schema_registry_url()
end
