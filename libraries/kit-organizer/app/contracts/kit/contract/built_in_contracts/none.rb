module Kit::Contract::BuiltInContracts

  class None < InstanciableType
    def initialize(*contracts)
      @contracts = contracts
    end

    def call(*args)
      passed = @contracts.any? do |contract|
        status, _ = Kit::Contract::Services::Validation.valid?(contract: contract, args: args)
        status == :ok
      end

      if passed
        [:error, "NONE failed"]
      else
        [:ok]
      end
    end
  end

end