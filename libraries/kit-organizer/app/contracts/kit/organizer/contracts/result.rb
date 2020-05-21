# Shortcut to specify Tupple[:ok, Hash[values]] || Tupple[:errors, Any]
class Kit::Organizer::Contracts::Result < Kit::Organizer::Contracts::InstanciableType

  # @hide true
  Ct = Kit::Organizer::Contracts

  def setup(keyword_args_contracts = nil)
    @state[:contract] = Ct::Or[
      Ct::Tupple[Ct::Eq[:ok], Ct::Hash[keyword_args_contracts]],
      Ct::Tupple[Ct::Eq[:error], Ct::Any],
    ]
  end

  def call(*args)
    Kit::Contract::Services::Validation.valid?(contract: @state[:contract], args: args)
  end

end
