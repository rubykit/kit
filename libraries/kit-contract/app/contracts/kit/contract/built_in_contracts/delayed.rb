# The actual contract is wrapped in a Callable and resolved on `call`.
# This enable circular reference on declaration.
class Kit::Contract::BuiltInContracts::Delayed < Kit::Contract::BuiltInContracts::InstantiableContract

  def setup(callable)
    @state[:callable] = callable
  end

  def call(*args, **kwargs)
    contract = @state[:callable].call()
    Kit::Contract::Services::Validation.valid?(contract: contract, parameters: { args: args })
  end

end
