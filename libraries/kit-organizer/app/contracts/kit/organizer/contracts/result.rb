# Shortcut to specify Tupple[:ok, Hash[values]] || Tupple[:errors, Any] with specific valid keyword arguments.
class Kit::Organizer::Contracts::Result < Kit::Organizer::Contracts::InstantiableContract

  # @doc false
  Ct = Kit::Organizer::Contracts

  def setup(keyword_args_contracts = nil)
    @state[:contract] = Ct::Or[
      Ct::Tupple[
        Ct::SuccessStatus,
        Ct::Hash[keyword_args_contracts].named('Result::SuccessTupple:Ctx'),
      ].named('Result:SuccessTupple'),
      Ct::Tupple[
        Ct::ErrorStatus,
        Ct::Any,
      ].named('Result:ErrorTupple'),
    ].named('Result:Or')
  end

  def call(*args)
    Kit::Contract::Services::Validation.valid?(contract: @state[:contract], args: args)
  end

end
