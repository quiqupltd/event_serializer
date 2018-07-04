use Mix.Config

config :tesla, adapter: Tesla.Mock

config :event_serializer,
  enabled: false
