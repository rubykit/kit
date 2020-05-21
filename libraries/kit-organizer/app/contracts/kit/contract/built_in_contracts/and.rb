# Ensure all contracts are successful
class Kit::Contract::BuiltInContracts::And < Kit::Contract::BuiltInContracts::InstanciableType

  def setup(*contracts)
    @state[:contracts] = contracts
  end

  def call(*args)
    failed_list = []
    @state[:contracts].each do |contract|
      status, res = Kit::Contract::Services::Validation.valid?(contract: contract, args: args)

      if status != :ok
        failed_list << res
      end
    end

    if failed_list.size > 0
      Kit::Error("AND failed: #{ failed_list.map { |ctx| ctx[:errors] } }")
    else
      [:ok]
    end
  end

end
