## Kit::Organizer

* [x] Spec accepted error tupple return values

* Spec `:keyrest` usage

* [x] We need a primitive to merge the context of N organized operations (maybe this only makes sense when merging :error ?)

* RESEARCH: "Never" monad with error reporting (:error is transformed to :ok for flow purposes, but the error is reported / saved?)
  * Investigate other return status, like :stop, :ok_stop ? ("should stop but isn't technically an error")

* RESEARCH: Code representation
  * Is the role of railway programming to ALWAYS go back to a `:ok` path for the caller ?
  * Should `organize` help represent higher order flows with branching ?
  * What primitives do we need to be able to represent code execution & reason about its validity?
    * Higher level "AST"
    * Contracts as a way to auto-generate tests && doc ? (through property testing ?)

  * Assess how to chain `flows` (cf: actions that need to be called regardless of the status of a previous flow). Not sure the tupple format serves us here.
    * Would replacing the tupple format with only a ctx with status: key help ?
    * The hash format would allow to have "flow metadata" (like explicit "stop" instead of :ok_stop)
    * Should this just be N call to organize ? (the danger I see is: easy to make a mistake and chain the organized calleables to get the context feeding behaviour even though they are not purely linear) >> Answer: if named flowed, no linearization, each new call to organize creates a new named flow. The glue just becomes: what is exposed from one flow to another, an on what conditions

  * There is something really promising in "flows" categorisation & code representation (would there be a way to know the full flow of a program at parsing time ?! >> NOPE. (or maybe with an explicit analysis mode on EVERY calleable))