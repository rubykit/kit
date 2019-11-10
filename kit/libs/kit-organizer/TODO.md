Kit::Contract
  - To deal with dynamically generated Class / Modules, the store should generate unique keys so that we don't depend on the Class / Module name, as it might not exist.

  - Move most of the code of the concern into a service

  - Delay `before` / `after` / `contract` failure to the method declaration

  - Do contracts work with ActiveSupport::Concern ?

  - Spec contract deactivation

  - How should we write documentation ?
    > Yard ?

  - Can we provide Before / After contracts for nested callables ?
      > Something like: `contract Hash[list: Array.of(Callable => ResultTupple)] => ResultTupple`
      > `Callable` is probably a special usecase in this regard


