defmodule EventSerializer.MixProject do
  use Mix.Project

  def project do
    [
      app: :event_serializer,
      version: "1.0.0",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {EventSerializer.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:avlizer, "~> 0.2.0"},
      {:poison, "~> 3.1.0"},
      {:tesla, "~> 1.2.0"},
      {:env_config, "~> 0.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp description, do: "Encode and decode events from Kafka"

  defp package do
    [
      files: ["lib", "mix.exs"],
      maintainers: [@luizvarela, @ianvaughan, @danhawkins],
      licenses: ["MIT"],
      links: %{repository: "https://github.com/quiqupltd/event_serializer"}
    ]
  end

  defp aliases do
    [
      test: ["test"],
      consistency: consistency()
    ]
  end

  defp consistency do
    [
      "credo --strict"
    ]
  end
end
