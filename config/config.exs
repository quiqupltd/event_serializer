# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.
config :avlizer,
  avlizer_confluent: %{
    schema_registry_url: 'http://localhost:8081'
  }

# {:system, :string, "AVLIZER_CONFLUENT_SCHEMAREGISTRY_URL", "http://localhost:8081"}
config :event_serializer,
  schema_registry_url: "http://localhost:8081",
  topic_name: "com.quiqup.tracking_locations",
  enabled: true,
  schema_registry: EventSerializer.SchemaRegistryCache,
  avlizer_confluent: :avlizer_confluent

import_config "#{Mix.env()}.exs"
