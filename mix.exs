defmodule EventSerializer.MixProject do
  use Mix.Project

  def project do
    [
      app: :event_serializer,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {EventSerializer.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:avlizer, "~> 0.2.0"},
      {:poison, "~> 3.1.0", override: true},
      {:tesla, "~> 0.10.0"},
      {:env_config, "~> 0.1.0"}
    ]
  end
end
