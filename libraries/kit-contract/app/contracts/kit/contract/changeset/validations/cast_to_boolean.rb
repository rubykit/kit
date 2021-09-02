module Kit::Contract::Changeset::Validations::CastToBoolean

  def self.call(value:, **)
    [:ok, value: (value == 'true')]
  end

end
