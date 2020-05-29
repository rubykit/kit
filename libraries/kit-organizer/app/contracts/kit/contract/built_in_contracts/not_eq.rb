# Ensure that the argument is different from the Contract value.
class Kit::Contract::BuiltInContracts::NotEq < Kit::Contract::BuiltInContracts::InstantiableContract

  def setup(expected_value)
    @state[:expected_value] = expected_value
  end

  def call(value)
    if value != @state[:expected_value]
      [:ok]
    else
      [:error, "NOT_EQ failed: expected `#{ @state[:expected_value] }` got `#{ value }`"]
    end
  end

end
