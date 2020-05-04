module Kit::Contract::BuiltInContracts

  class Optional < InstanciableType
    def initialize(contract)
      @contract = contract
    end

    def call(value = nil)
      if value == nil
        [:ok]
      else
        Kit::Contract::Services::Validation.valid?(contract: @contract, args: [value])
      end
    end
  end

end