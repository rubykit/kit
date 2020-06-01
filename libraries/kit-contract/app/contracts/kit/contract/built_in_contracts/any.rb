# Always succeeds.
class Kit::Contract::BuiltInContracts::Any

  def self.call(value = nil)
    [:ok]
  end

end
