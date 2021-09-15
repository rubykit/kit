 Kit::Router


## Router architecture

### Router configuration

The `Router` configuration is **per application container**.

The `Router` is responsible for mapping protocols to `endpoints` and delivering messages between domains.

In order to do this, it needs to be aware of the production topology.

- Is the app a monolith & can message delivery be a simple function call?
- Is a given domain deployed as it's own app?

### Router flow

Note: any `endpoint` is called through an `adapter`.

**INBOUND MESSAGE**
  |-> through a call to the Router (cast, call, inline_call)
  |-> through an **external listener**, translates the call to a `RouterRequest`

**BROKER**
  |-> Call subscribed `endpoints` to process the `RouterRequest`

Note: the adapters can be re-entrant depending on the strategies.

### Router entry points

- `externals`: calling an endpoint through an adapter own listeners. Ex:
  - http
  - websocket
  - sidekiq

- `internals`: calling the router directly in the code, through `cast` , `call`, `inline_call`

---



## Internal: using the Router to call `endoints` manually

The differences are based on the expectation **at the call site**.

- `call` is used when a return value is expected. It's a sync primitive: the method will block until a response is received (or a timeout occurs).
- `cast` is used when no return value is expected. It's an async primitive: the method is non-blocking and will return immediatel ("fire-and-forget").

`call` & `cast` use the router's broker to determine what adapter should be used to call the endpoint

!!! HOW DOES THIW WORK IF AN ENDPOINT IS MOUNTED THROUGH HTTP ADAPTER AND `call` is used ??? WHAT ADAPTER IS USED?

- `inline_call` has the same behaviour than `call`, but it force the use of the `inline` strategy. This strategy ensures that all code gets executed in the same execution context. This is mostly usefull inside `adapters`.

### References

- [Elixir GenServer#call](https://hexdocs.pm/elixir/GenServer.html#call/3)
- [Elixir GenServer#cast](https://hexdocs.pm/elixir/GenServer.html#cast/3)



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









------

# IS THIS USEFUL AT ALL?!

## Messages: two "families"

- "Internal" message: how to call an endpoint + expected parameters!
- Per "procotol" messages: how to react / routes protocol messages.

### Message format

```
[protocol, { specifics? }]
```
