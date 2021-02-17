# Ensure no contract is successful
class Kit::Contract::BuiltInContracts::None < Kit::Contract::BuiltInContracts::InstantiableContract

  def setup(*contracts)
    @state[:contracts_list] = contracts
  end

  def call(*args)
    debug(parameters: parameters)

    safe_nested_call(list: @state[:contracts_list], parameters: parameters, contract: self) do |local_contract|
      status, ctx = result = Kit::Contract::Services::Validation.valid?(contract: local_contract, parameters: parameters)
      if status == :ok
        ctx[:errors].unshift({ detail: 'NONE failed.' })

        return result
      end
    end

    [:ok]
  end

end
