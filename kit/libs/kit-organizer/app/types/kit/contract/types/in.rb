module Kit::Contract::Types

  # Acts as an enum
  # Or[Eq[:ok], Eq[:error]] == In[:ok, :error]
  # Handle ranges too
  class In < InstanciableType

    def initialize(*expected_values)
      @expected_values = expected_values
    end

    def call(value)
      expected_values = @expected_values

      passed = expected_values.any? do |expected_value|
        if expected_value.is_a?(::Range)
          status = expected_value.include?(value)
        else
          status = expected_value == value
        end
      end

      if passed
        [:ok]
      else
        [:error, "IN failed: `#{value}` is not in `#{expected_values}`"]
      end
    end

  end

end