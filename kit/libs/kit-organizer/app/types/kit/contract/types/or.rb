module Kit::Contract::Types

  class Or < InstanciableType
    def initialize(*contracts)
      @contracts = contracts
    end

    def call(*args)
      passed = @contracts.any? do |contract|
        status, _ = Kit::Contract::Services::Validate.valid?(contract: contract, args: args)
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