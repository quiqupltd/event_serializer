defmodule EventSerializer.SchemaRegistryAdapter do
  @moduledoc """
  This module is resposible to fetch the schemas from the schema registry.
  """
  use Tesla

  alias EventSerializer.Config

  plug(Tesla.Middleware.Headers, %{"Content-Type" => "application/json"})
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger)

  def schema_for(name) do
    name |> fetch_schema() |> Map.fetch!("schema")
  end

  def schema_id_for(name) do
    name |> fetch_schema() |> Map.fetch!("id")
  end

  defp fetch_schema(name) do
    name
    |> url()
    |> get()
    |> parse_response()
  end

  defp parse_response(response) do
    response.body |> Poison.decode!()
  end

  defp url(name) do
    "#{base_url()}/subjects/#{name}/versions/latest"
  end

  defp base_url do
    Config.schema_registry_url()
  end
end
