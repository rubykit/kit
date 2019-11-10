Kit::Contract

  - Should we rename all "types" to avoid collisions ? (needed if we move to Object concern extension)

  - Investigate loop when enabling contract on `Kit::Contract::Services::Validation.valid?`

  - To deal with dynamically generated Class / Modules, the store should generate unique keys so that we don't depend on the Class / Module name, as it might not exist.

  - Move most of the code of the Contract concern into a service
  - Research: can we avoid having it be a concern at all ? (and not store anything in classes)

  - Delay `before` / `after` / `contract` failure to the method declaration

  - Do contracts work with ActiveSupport::Concern ?

  - Improve error messages

  - Spec contract deactivation

  - How should we write documentation ?
    > Yard ?

  - Can we provide Before / After contracts for nested callables ?
      > Something like: `contract Hash[list: Array.of(Callable => ResultTupple)] => ResultTupple`
      > `Callable.before(Hash[a: Symbol]).after(ResultTupple)` seems doable by adding the indirection
      > `Callable` is probably a special usecase in this regard


