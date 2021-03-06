# Ensure that Contract is obeyed when not nil.
class Kit::Contract::BuiltInContracts::Optional < Kit::Contract::BuiltInContracts::InstantiableContract

  def setup(contract)
    @state[:contract] = contract
  end

  def call(value = nil)
    if value == nil
      [:ok]
    else
      Kit::Contract::Services::Validation.valid?(contract: @state[:contract], parameters: { args: [value] })
    end
  end

end
