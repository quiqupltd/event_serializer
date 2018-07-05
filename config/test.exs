use Mix.Config

config :tesla, adapter: Tesla.Mock

config :event_serializer,
  enabled: false,
  schema_registry: EventSerializer.TestSupport.Mocks.CourierActivityMock,
  avlizer_confluent: EventSerializer.TestSupport.Mocks.AvlizerConfluentMock
