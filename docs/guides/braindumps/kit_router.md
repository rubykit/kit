# Kit::Router

## Router entry points

- `inline` (calling the router directly): `cast` , `call`, `inline_call`
- per adapter or protocol `listeners`

## Making an inline call to the Router

The only differentiator is based on the expectation **at the call site**: do we expect an answer or not?

- `call` blocks (until there is a response or a timeout). It's a sync primitive from the caller perspective.
- `cast` is non-blocking. It's an async primitive from the caller perspective ("fires & forget").
- `inline_call` is the same than calls but it force the use of the `inline` strategy (mostly usefull inside adapters).

(Context: https://hexdocs.pm/elixir/GenServer.html#call/3)

## Messages: two "families"

- "Internal" message: how to call an endpoint + expected parameters!
- Per "procotol" messages: how to react / routes protocol messages.

## Router flow

**INBOUND MESSAGE**
  |-> **inline** (expects a valid `RouterRequest`)
  |-> through an **external listener**, translates the call to a `RouterRequest`

**BROKERS**
  |-> Call subscribed `endpoints` to process the `RouterRequest`

Note: the brokers can be re-entrant depending on the strategies.

### Message format

```
[protocol, { specifics? }]
```

## Router behaviour

The `Router` configuration is **per application container**.

The `Router` is responsible for delivering messages between domains. In order to do this, it needs to know the production topology. (Is the app a monolith & can message delivery be a simple function call? Is a given domain deployed as it's own app?)

## Adapters

Need to be as flexible as possible to allow for widely different strategies.

```
SHOULD ADAPTERS:
- ALLOW FOR INDIRECTION (easiest way to implemenent "families" :http >> :http_sync, :http_async_sidekiq)
- ALLOW FOR CHAINING: :http (handle route) > :http_async
OR IS HTTP JUST A WEIRD ONE BECAUSE OF THE MESSAGE PARSING?
```

LISTENERS: :internal, :http, :websocket, :emails, :events_sidekiq, :http_sidekiq (:async_sidekiq?)



BROKERS: :http_sync, :http_async_sidekiq, :events, :emails


```
[:http, [:GET,    '/items/:uid']] >> HTTP ADAPTER >> HTTP SYNC ADAPTER >> ENDPOINT
[:http, [:CREATE, '/pdf_assets']] >> HTTP ADAPTER >> HTTP ASYNC ADAPTER >> ENDPOINT

[:event, ['kit_auth.reset_password_requested']] >> 
```

[]

Protocols:
  Inbound:
    - http
    - http_async
    - websocket
    - emails
    - events_in (through any broker: sidekiq, rabbit mq, kafka)
  Outbound:
    - events_out ()


------

# Kit::EventBroker

An adapter for Kit::Router.

When emitted: either received sync or async depending on the strategy.

Received by a generic EventBroker endpoint that can multiplex it if needed, sync or async!

