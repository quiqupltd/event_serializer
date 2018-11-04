defmodule EventSerializer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec

  def start(_type, _args) do
    children = children(%{enabled: enabled?()})
    opts = [strategy: :one_for_one, name: EventSerializer.Supervisor]

    Supervisor.start_link(children, opts)
  end

  defp children(%{enabled: true}) do
    [
      supervisor(EventSerializer.SchemaRegistryCache, [])
    ]
  end

  defp children(_), do: []

  defp enabled? do
    EventSerializer.Config.enabled?()
  end
end
