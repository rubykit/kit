module Kit::Contract::Types

  # Ensures all contracts are valid
  class And < InstanciableType
    def initialize(*contracts)
      @contracts = contracts
    end

    def call(args)
      failed = @contracts.any? do |contract|
        status, _ = Kit::Contract::Services::Types.valid?(contract: contract, args: args)
        status != :ok
      end

      if failed
        [:error, "AND failed"]
      else
        [:ok]
      end
    end
  end

end