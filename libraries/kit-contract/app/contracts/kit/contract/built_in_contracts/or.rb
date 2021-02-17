# Ensure at least one contract is successful
class Kit::Contract::BuiltInContracts::Or < Kit::Contract::BuiltInContracts::InstantiableContract

  def setup(*contracts)
    @state[:contracts_list] = contracts
  end

  # Note: not sure what the correct behaviour is here with safe_nested_call.
  #  Should it remove circular reference contracts or pretend they succeeded? Does it make a difference?
  def call(*args, **kwargs)
    parameters = { args: args || [], kwargs: kwargs || {}, }

    results = safe_nested_call(list: @state[:contracts_list], parameters: parameters, contract: self) do |local_contract|
      status, _ctx = result = Kit::Contract::Services::Validation.valid?(contract: local_contract, parameters: parameters)

      return [:ok] if status == :ok

      result
    end

    failed = results.select { |status, _| status == :error }

    if failed.size == 0 || failed.size != @state[:contracts_list].size
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
