defmodule EventSerializer.SchemaRegistryAdapterTest do
  use ExUnit.Case, async: true

  alias EventSerializer.SchemaRegistryAdapter, as: Subject

  setup do
    schema_registry_url = EventSerializer.Config.schema_registry_url()
    schema_name = "com.tracking_locations"

    url = "#{schema_registry_url}/subjects/#{schema_name}/versions/latest"

    %{schema_registry_url: url, schema_name: schema_name}
  end

  describe "schema_for/1" do
    test "returns nil when cannot connect to the scheme regisity", %{
      schema_registry_url: url,
      schema_name: schema_name
    } do
      Tesla.Mock.mock(fn %{method: :get, url: ^url} ->
        raise %Tesla.Error{message: "adapter error: :econnrefused", reason: :econnrefused}
      end)

      response = {
        :error,
        %Tesla.Error{
          message: "adapter error: :econnrefused",
          reason: :econnrefused
        }
      }
      assert Subject.schema_for(schema_name) == response
    end

    test "returns nil when the schema cannot be found", %{
      schema_registry_url: url,
      schema_name: schema_name
    } do
      Tesla.Mock.mock(fn %{method: :get, url: ^url} ->
        response = %{"error_code" => 40401, "message" => "Subject not found."}
        response |> tesla_response(404)
      end)

      assert Subject.schema_for(schema_name) == {:error, "Subject not found."}
    end

    test "fetches the schema from the payload response", %{
      schema_registry_url: url,
      schema_name: schema_name
    } do
      Tesla.Mock.mock(fn %{method: :get, url: ^url} ->
        %{id: 42, schema: "my schema"} |> tesla_response(200)
      end)

      assert Subject.schema_for(schema_name) == "my schema"
    end
  end

  describe "schema_id_for/1" do
    test "fetches the schema id from the payload response", %{
      schema_registry_url: url,
      schema_name: schema_name
    } do
      Tesla.Mock.mock(fn %{method: :get, url: ^url} ->
        %{id: 42, schema: "my schema"} |> tesla_response(200)
      end)

      assert Subject.schema_id_for(schema_name) == 42
    end
  end

  defp tesla_response(body, status) do
    %Tesla.Env{status: status, body: Poison.encode!(body)}
  end
end
