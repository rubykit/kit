## Kit::Contract

* Spec contract deactivation.
* Contract deactivaton
  * Add specs
  * Should we add a notion of tag / "types" for contracts so that we can tune what gets disabled ? (Useful if a contract performs checks that is actually part of the operations, like "check that the user is not in the DB")
  * Add `dev_contract` ?

* Investigate loop when enabling contract on `Kit::Contract::Services::Validation.valid?`

* Delay `before` / `after` / `contract` failure to the method declaration for clarity

* Do contracts work with ActiveSupport::Concern ?

* Improve error messages when nesting (attempt to hydrate error message)

* Add types (taken from callable)
  * None
  * Func "specifies the contract for a proc/lambda e.g. Contract ArrayOf[Num], Func[Num => Num] => ArrayOf[Num]. See section "Contracts On Functions" (see "the nested")
    * Something like: `contract Hash[list: Array.of(Callable => ResultTupple)] => ResultTupple`
    * `Callable.before(Hash[a: Symbol]).after(ResultTupple)` seems doable by adding the indirection
    * `Callable` is probably a special usecase in this regard
    * Look at http://egonschiele.github.io/contracts.ruby/ Func


