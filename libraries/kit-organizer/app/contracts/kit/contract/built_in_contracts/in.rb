# Acts as an enum.
# Supports Ranges.
#
# Examples
# ```ruby
# # The two following are similar:
# In[:ok, :error]
# Or[Eq[:ok], Eq[:error]]
# ```
class Kit::Contract::BuiltInContracts::In < Kit::Contract::BuiltInContracts::InstanciableType

  def setup(*expected_values)
    @state[:expected_values] = expected_values
  end

  def call(value)
    expected_values = @state[:expected_values]

    passed = expected_values.any? do |expected_value|
      if expected_value.is_a?(::Range)
        expected_value.include?(value)
      elsif expected_value.is_a?(self.class)
        expected_value.call(value)[0] == :ok
      else
        expected_value == value
      end
    end

    if passed
      [:ok]
    else
      [:error, "IN failed: `#{ value }` is not in `#{ beautified_values }`"]
    end
  end

  def beautified_values
    values = @expected_values.map do |expected_value|
      if expected_value.is_a?(self.class)
        "In#{ expected_value.beautified_values }"
      else
        expected_value.inspect
      end
    end

    "[#{ values.join(', ') }]"
  end

end
