use Mix.Config

config :tesla, adapter: Tesla.Mock

config :event_serializer,
  enabled: false,
  schema_registry: EventSerializer.TestSupport.Mocks.CourierActivityMock,
  avlizer_confluent: EventSerializer.TestSupport.Mocks.AvlizerConfluentMock,
  schema_registry_adapter: EventSerializer.TestSupport.Mocks.SchemaRegistryAdapterMock
