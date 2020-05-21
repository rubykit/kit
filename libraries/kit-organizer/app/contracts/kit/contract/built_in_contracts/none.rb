class Kit::Contract::BuiltInContracts::None < Kit::Contract::BuiltInContracts::InstanciableType

  def setup(*contracts)
    @state[:contracts] = contracts
  end

  def call(*args)
    passed = @state[:contracts].any? do |contract|
      status, _ctx = Kit::Contract::Services::Validation.valid?(contract: contract, args: args)
      status == :ok
    end

    if passed
      [:error, 'NONE failed']
    else
      [:ok]
    end
  end

end
