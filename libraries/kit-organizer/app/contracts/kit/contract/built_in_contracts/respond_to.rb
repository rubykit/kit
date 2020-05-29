# Ensure that the object `respond_to?` a specific method.
class Kit::Contract::BuiltInContracts::RespondTo < Kit::Contract::BuiltInContracts::InstantiableContract

  def setup(method_name)
    @state[:method_name] = method_name
  end

  def call(arg)
    if arg.respond_to?(@state[:method_name])
      [:ok]
    else
      [:error, "RESPOND_TO failed: object does not respond_to `#{ @state[:method_name] }`"]
    end
  end

  def contract_safe?
    true
  end

end
