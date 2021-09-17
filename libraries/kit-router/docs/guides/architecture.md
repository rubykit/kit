# Architecture

## Router configuration

The `Router` configuration is **per application container**.

The `Router` is responsible for mapping adapters to `endpoints` and delivering messages between domains.

In order to do this, it needs to be aware of the production topology.

- Is the app a monolith & can message delivery be a simple function call?
- Is a given domain deployed as it's own app?

## Router flow

Every `endpoint` is called through an `adapter`.

**INBOUND MESSAGE**
  |-> through a call to the Router (cast, call)
  |-> through an **external adapter**, wrap the connection through a `RouterConn`

**BROKER**
  |-> Call subscribed `endpoints` to process the `RouterRequest`

## Router entry points

- `externals`: calling an endpoint through an adapter own listeners. Ex:
  - http
  - websocket
  - sidekiq

- `internals`: calling the router directly in the code, through `cast` , `call`

## Using the Router to call `endoints` manually

The differences are based on the expectation **at the call site**.

- `call` is used when a return value is expected. It's a sync primitive: the method will block until a response is received (or a timeout occurs).
- `cast` is used when no return value is expected. It's an async primitive: the method is non-blocking and will return immediatel ("fire-and-forget").

`call` & `cast` use the router's broker to determine what adapter should be used to call the endpoint

!!! HOW DOES THIW WORK IF AN ENDPOINT IS MOUNTED THROUGH HTTP ADAPTER AND `call` is used ??? WHAT ADAPTER IS USED?

- `inline_call` has the same behaviour than `call`, but it force the use of the `inline` strategy. This strategy ensures that all code gets executed in the same execution context. This is mostly usefull inside `adapters`.

### References

- [Elixir GenServer#call](https://hexdocs.pm/elixir/GenServer.html#call/3)
- [Elixir GenServer#cast](https://hexdocs.pm/elixir/GenServer.html#cast/3)
