# EventSerializer

This lib is responsible to encode and decode events from Kafka. it also includes a cache to fetch schemas.

## Installation

```elixir
def deps do
  [
    {:event_serializer, "~> 0.1.1", organization: :quiqup}
  ]
end
```

## Usage

After add the lib in the dependencies add it in the applications list, `:event_serializer`.

In your `config.exs` add the following vars:

```elixir
config :avlizer,
  avlizer_confluent: %{
    schema_registry_url: 'http://localhost:8081'
  }

config :event_serializer,
  schema_registry_url: "http://localhost:8081",
  topic_name: "com.example.topic.name",
  enabled: true
```
We need those two `schema_registry_url` because the `avlizer` requires it.

Under tests you will want to disable the starting the child processes that
caches the schemes, so it doesn't try and connect to Schema Registry and die
```
enabled: false
```

### Encoding Messages

Just call the `EventSerializer.Encoder.call/1` passing the message.

The message needs to be a list of tuples. It's required by the `avlizer`.

```elixir
{:ok, encoded_message} = EventSerializer.Encoder.call(message)
```

### Decoding Messages

Just call the `EventSerializer.Decoder.call/1` passing the message.

```elixir
{:ok, decoded_message} = EventSerializer.Decoder.call(message)
```

The message is also converted to a map with string key within the response.

String keys are recommend due the performance.

## Publish to HEX

https://hex.pm/packages/quiqup/event_serializer

```elixir
mix hex.organization auth quiqup
mix hex.publish
```

## TODO

- [ ] Add tests.
- [ ] Add type check for all functions.
