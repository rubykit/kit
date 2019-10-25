module Kit::Contract::Types

  class None < InstanciableType
    def initialize(*contracts)
      @contracts = contracts
    end

    def call(args)
      passed = @contracts.any? do |contract|
        status, _ = Kit::Contract::Services::Types.valid?(contract: contract, args: args)
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