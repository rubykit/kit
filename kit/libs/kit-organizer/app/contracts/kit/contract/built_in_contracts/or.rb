module Kit::Contract::BuiltInContracts

  class Or < InstanciableType
    def initialize(*contracts)
      @contracts = contracts
    end

    def call(*args)
      results = @contracts.map do |contract|
        Kit::Contract::Services::Validation.valid?(contract: contract, args: args)
      end

      passed = results.any? do |status, ctx|
        status == :ok
      end

      if passed
        [:ok]
      else
        #puts "--------------------"
        #puts results
        [:error, "OR failed"]
      end
    end
  end

end