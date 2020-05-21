# Ensure that the Contract value is of a given Type.
class Kit::Contract::BuiltInContracts::IsA < Kit::Contract::BuiltInContracts::InstanciableType

  def setup(type)
    @state[:type] = type
  end

  def call(value)
    if value.is_a?(@state[:type])
      [:ok]
    else
      [:error, "IS_A failed: expected `#{ value.inspect }` of type `#{ value.class }` to be of type `#{ @state[:type] }`"]
    end
  end

end
