# Ensure that the argument equals the saved Contract value
class Kit::Contract::BuiltInContracts::Eq < Kit::Contract::BuiltInContracts::InstanciableType

  def setup(expected_value)
    @state[:expected_value] = expected_value
  end

  def call(value)
    if value == @state[:expected_value]
      [:ok]
    else
      [:error, "EQ failed: expected `#{ @state[:expected_value] }` got `#{ value }`"]
    end
  end

end
