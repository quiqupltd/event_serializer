defmodule EventSerializer.SchemaRegistryCache do
  @moduledoc """
  This service is responsible to fetch the schemas from Schema Registry
  and cache theirs names and ids.

  That result will be saved in a cache so we can re utilize in the
  EventSerializer.Publisher

  We start the server using the start_link/0 function:

    EventSerializer.SchemaRegistryServer.start_link()

  Then we can fetch the id of the schema using the fetch/1 function.

    EventSerializer.SchemaRegistryServer.fetch("com.quiqup.tracking-key")
  """

  defmodule State do
    @moduledoc """
    This struct will represent the state of this GenServer.
    """
    defstruct [:id, :name]
  end

  use GenServer

  require Logger

  alias EventSerializer.Config

  @name __MODULE__

  def start_link do
    GenServer.start_link(@name, [], name: @name)
  end

  @doc """
  This function starts the server and perform the cache.
  """
  def init(state) do
    cache()
    {:ok, state}
  end

  def cache, do: GenServer.cast(@name, :cache)

  def fetch(schema_name), do: GenServer.call(@name, {:fetch, schema_name})

  def handle_cast(:cache, _state) do
    result = fetch_schemas()

    new_state = Enum.map(result, fn schema -> struct(State, schema) end)

    {:noreply, new_state}
  end

  def handle_call({:fetch, schema_name}, _from, state) do
    schema = Enum.find(state, fn subject -> subject.name == schema_name end)

    {:reply, extract_id(schema), state}
  end

  defp extract_id(schema) when is_nil(schema), do: nil
  defp extract_id(schema), do: schema.id

  @doc """
  This function fetches the schema ids from the Schema Registry.

  The :avlizer_confluent is used to fetch and cache the schema body.
  make_encoder function is resposible to do that. More information in the docs:
  https://github.com/klarna/avlizer/blob/master/src/avlizer_confluent.erl#L97

  The return of this function is a list of maps containing the schema name and id,
  which will be cached for future requests.

  The return will be like this:

  ## Example

    [
      %{name: "com.quiqup.tracking-value", schema_id: 13},
      %{name: "com.quiqup.tracking-key", schema_id: 12}
    ]
  """
  def fetch_schemas do
    schema_name_id = key_schema_name() |> fetch_id()
    schema_value_id = value_schema_name() |> fetch_id()

    avlizer_confluent().make_encoder(schema_name_id)
    avlizer_confluent().make_encoder(schema_value_id)

    [
      %{id: schema_name_id, name: key_schema_name()},
      %{id: schema_value_id, name: value_schema_name()}
    ]
  end

  def fetch_id(name) do
    schema_registry_adapter().schema_id_for(name)
  end

  def key_schema_name do
    topic() <> "-key"
  end

  def value_schema_name do
    topic() <> "-value"
  end

  defp topic do
    Config.topic_name()
  end

  defp avlizer_confluent do
    EnvConfig.get(:event_serializer, :avlizer_confluent)
  end

  defp schema_registry_adapter do
    EnvConfig.get(:event_serializer, :schema_registry_adapter)
  end
end
