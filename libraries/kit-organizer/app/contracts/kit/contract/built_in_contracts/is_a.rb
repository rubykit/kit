module Kit::Contract::BuiltInContracts

  class IsA < InstanciableType
    def initialize(type)
      @type = type
    end

    def call(value)
      if value.is_a?(@type)
        [:ok]
      else
        [:error, "IS_A failed: expected `#{value.inspect}` of type `#{value.class}` to be of type `#{@type}`"]
      end
    end
  end

end