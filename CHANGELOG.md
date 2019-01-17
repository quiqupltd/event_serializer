# Changelog for event_serializer

## 2.0.2

- Extend Config.topic_names to allow CSV and functions

## 2.0.1

- Fix decoding nulls into proper nils

## 2.0.0

- Allow for multiple topics in configuration


## 1.0.0

- Update to user Testa 1.2.0

## 0.1.5

- Add .credo - Code analysis tool
- Decode fails on invalid payload
- Encoding with invalid payload blows up

## 0.1.4

- Added more safety around decoding and caching
- Fixed decoding larger schema_ids

## 0.1.3

- Default the internal config so clients don't have to set it
- Allow application to boot even when Schema Registry is unreachable or topic cannot be found

## 0.1.2

- Add tests and error handling
