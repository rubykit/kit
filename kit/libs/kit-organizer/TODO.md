Kit::Contract

  - What can technically be handled:
    > Keyword args: pattern matching (the name of the keys for the sender / receiver need to match)
    > KeyRest
    > Arity
    Signature matching & transformation code needed.

  - Figure out how to handle Kit::Contract::Error display / message / to_s

  - Do contracts work with ActiveSupport::Concern ?

  - Spec contract deactivation

  - How should we write documentation ?
    > Yard ?

  - Can we provide Before / After contracts for nested callables ?
      > Something like: `contract Hash[list: Array.of(Callable => ResultTupple)] => ResultTupple`
      > `Callable` is probably a special usecase in this regard


