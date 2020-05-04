module Kit::Contract::BuiltInContracts

  # Ensures all contracts are valid
  class And < InstanciableType
    def initialize(*contracts)
      @contracts = contracts
    end

    def call(*args)
      failed_list = []
      @contracts.each do |contract|
        status, res = Kit::Contract::Services::Validation.valid?(contract: contract, args: args)

        if status != :ok
          failed_list << res
        end
      end

      if failed_list.size > 0
        [:error, "AND failed: #{failed_list.map { |ctx| ctx[:errors] } }"]
      else
        [:ok]
      end
    end
  end

end