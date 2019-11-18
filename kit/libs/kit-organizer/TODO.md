## Kit::Contract

* Handle `before String, Symbol => Boolean` (currently we only support 1 argument)

* Should we rename all "types" to avoid collisions ? (needed if we move to Object concern extension)

* Investigate loop when enabling contract on `Kit::Contract::Services::Validation.valid?`

* To deal with dynamically generated Class / Modules, the store should generate unique keys so that we don't depend on the Class / Module name, as it might not exist.

* Move most of the code of the Contract concern into a service
* Research: can we avoid having it be a concern at all ? (and not store anything in classes)

* Delay `before` / `after` / `contract` failure to the method declaration

* Do contracts work with ActiveSupport::Concern ?

* Improve error messages

* Add types (taken from callable)
  * None
  * Func "specifies the contract for a proc/lambda e.g. Contract ArrayOf[Num], Func[Num => Num] => ArrayOf[Num]. See section "Contracts On Functions" (see "the nested")

* Spec contract deactivation.
* Contract deactivaton
  * Add specs
  * Should we add a notion of tag / "types" for contracts so that we can tune what gets disabled ? (Useful if a contract performs checks that is actually part of the operations, like "check that the user is not in the DB")

* Can we provide Before / After contracts for nested callables ?
  * Something like: `contract Hash[list: Array.of(Callable => ResultTupple)] => ResultTupple`
  * `Callable.before(Hash[a: Symbol]).after(ResultTupple)` seems doable by adding the indirection
  * `Callable` is probably a special usecase in this regard
  * Look at http://egonschiele.github.io/contracts.ruby/ Func


