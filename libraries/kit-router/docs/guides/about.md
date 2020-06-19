# About Routing

Traditionally, frameworks create different categories of scenarios to expose different protocols. This leads to extra complexity and hinders extensibility.

## Endpoints

An `endpoint` is a callable that accepts a `request object`, and returns a `response` (TODO: figure out what this response is!).
Every `endpoint` needs to be registered against the `Router` with a `UID`, and `aliases` if needed.

## Protocols

A `protocol` is an adapter to the external world. Currently the following are supported:
- `HTTP`
- `Async` (through `redis` & a relational store)
Future candidates include `WebSockets`, `Emails`, `Sms`, `RabbitMQ`, `Kafka`, `Spark`.

An application can then `mount` (expose) these `aliases` or `UIDs` on various `protocols`.

Through these `UID` & `aliases`, the `endpoint` can be mounted in the `router`.