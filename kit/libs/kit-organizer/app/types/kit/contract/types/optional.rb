module Kit::Contract::Types

  class Optional < InstanciableType
    def initialize(contract)
      @contract = contract
    end

    def call(value)
    end

    def self.call(value = nil)
      if value == nil
        [:ok]
      else
        Kit::Contract::Services::Validation.valid?(contract: @contract, args: [value])
      end
    end
  end

end