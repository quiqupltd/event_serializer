defmodule EventSerializer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: EventSerializer.Worker.start_link(arg)
      # {EventSerializer.Worker, arg},
      supervisor(EventSerializer.SchemaRegistryCache, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventSerializer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
