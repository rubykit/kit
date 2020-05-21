# Ensure at least one contract is successful
class Kit::Contract::BuiltInContracts::Or < Kit::Contract::BuiltInContracts::InstanciableType

  def setup(*contracts)
    @state[:contracts] = contracts
  end

  def call(*args)
    results = @state[:contracts].map do |contract|
      Kit::Contract::Services::Validation.valid?(contract: contract, args: args)
    end

    failed = results.select { |status, _| status == :error }

    if failed.size != @state[:contracts].size
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
