# Ensure at least one contract is successful
class Kit::Contract::BuiltInContracts::Or < Kit::Contract::BuiltInContracts::InstanciableType

  def setup(*contracts)
    @state[:contracts_list] = contracts
  end

  def call(*args)
    results = safe_nested_call(list: @state[:contracts_list], args: args, contract: self) do |local_contract|
      Kit::Contract::Services::Validation.valid?(contract: local_contract, args: args)
    end

    failed = results.select { |status, _| status == :error }

    if failed.size != @state[:contracts_list].size
      [:ok]
    else
      errors = [{ detail: 'OR failed' }]
      failed.each do |_status, ctx|
        errors += ctx[:errors]
      end

      [:error, {
        errors:         errors,
        contract_error: failed[0][1][:contract_error],
      },]
    end
  end

end
