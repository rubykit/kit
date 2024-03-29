# Ensure all contracts are successful
class Kit::Contract::BuiltInContracts::And < Kit::Contract::BuiltInContracts::InstantiableContract

  def setup(*contracts)
    @state[:contracts_list] = contracts
  end

  def call(*args)
    parameters = { args: args }

    debug(parameters: parameters)

=begin
    failed_list = []

    safe_nested_call(list: @state[:contracts_list], parameters: parameters, contract: self) do |local_contract|
      status, res = Kit::Contract::Services::Validation.valid?(contract: local_contract, args: args)

      if status == :err
        failed_list << res
      end
    end

    if failed_list.size > 0
      Kit::Error("AND failed: #{ failed_list.map { |ctx| ctx[:errors] } }")
    else
      [:ok]
    end
=end

    safe_nested_call(list: @state[:contracts_list], parameters: parameters, contract: self) do |local_contract|
      status, ctx = result = Kit::Contract::Services::Validation.valid?(contract: local_contract, parameters: parameters)

      if status == :error
        if ctx[:contracts_stack]
          ctx[:contracts_stack] << contract
        end

        ctx[:errors].unshift({ detail: 'AND failed.' })

        return result
      end
    end

    [:ok]
  end

end
