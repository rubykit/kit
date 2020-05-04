module Kit::Contract::BuiltInContracts

  class Delayed < InstanciableType
    def initialize(callable)
      @callable = callable
    end

    def call(*args)
      contract = @callable.call()
      Kit::Contract::Services::Validation.valid?(contract: contract, args: args)
    end
  end

end