# Changelog for event_serializer

## 0.1.5

* [issue/2][2] Add .credo - Code analysis tool
* [issue/18][18] Decode fails on invalid payload
* [issue/17][17] Encoding with invalid payload blows up

[2]: https://gitlab.quiqup.com/backend/event_serializer/issues/2
[17]:https://gitlab.quiqup.com/backend/event_serializer/issues/17
[18]:https://gitlab.quiqup.com/backend/event_serializer/issues/18

## 0.1.4

* Added more safety around decoding and caching
* Fixed decoding larger schema_ids

## 0.1.3

* [merge_requests/10][10] Default the internal config so clients don't have to set it
* [merge_requests/9][9] Allow application to boot even when Schema Registry is unreachable
or topic cannot be found

[10]: https://gitlab.quiqup.com/backend/event_serializer/merge_requests/10
[9]: https://gitlab.quiqup.com/backend/event_serializer/merge_requests/9

## 0.1.2

* [merge_requests/6][6] Add tests and error handling

[6]: https://gitlab.quiqup.com/backend/event_serializer/merge_requests/6