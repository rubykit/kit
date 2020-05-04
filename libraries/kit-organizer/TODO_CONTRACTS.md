## Kit::Contract

* Make contracts work with `ActiveSupport::Concern`!

* Spec contract deactivation
  * Should we add a notion of tag / "types" for contracts so that we can tune what gets disabled ? (Useful if a contract performs checks that is actually part of the operations, like "check that the user is not in the DB")
  * Add `dev_contract` ?

* Improve error messages when nesting (attempt to hydrate error message)
  * Look at contract ruby

* Add accumulator when nesting contracts. This would prevent infinite loops when there is a circular reference.
  * Keep track of the result of contracts for every tupple `[ContractInstance, Value]`
  * Probably the cause of infinite loop on `Kit::Contract::Services::Validation.valid?`

* Default `value` inside `InstanciableType` initializer to `Eq[value]`

* Delay `before` / `after` / `contract` failure to the method declaration for clarity

* Add types
  * None
  * Func (callable wrapping). BLOCKED: in order to do this we need to modify `args` and become non hygienic. Not sure this is a good thing.

* RESEARCH: should a signature contract be able to modify the arguments of the target callable?
  * Useful for: Proc / Lambda wrapping, setting default parameters in contracts
