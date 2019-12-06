module Kit::Contract::BuiltInContracts

  class Or < InstanciableType
    def initialize(*contracts)
      @contracts = contracts
    end

    def call(*args)
      passed = @contracts.any? do |contract|
        status, _ = Kit::Contract::Services::Validation.valid?(contract: contract, args: args)
        if status != :ok
          puts _
        end
        status == :ok
      end

      if passed
        [:ok]
      else
        [:error, "OR failed"]
      end
    end
  end

end