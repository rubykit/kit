module Kit::Contract::Types

  class Eq < InstanciableType
    def initialize(expected_value)
      @expected_value = expected_value
    end

    def call(value)
      if value == @expected_value
        [:ok]
      else
        [:error, "EQ failed: expected `#{@expected_value}`, got `#{value}`"]
      end
    end
  end

end