class Kit::Contract::Changeset::Validations::CastToInteger < Kit::Contract::Changeset::Validations::WithError

  def self.default_error
    'Please enter a number.'
  end

  def self.call(value:, error: nil, **)
    error ||= default_error
    value_i = value.to_i

    if value_i != 0 || value == '0' || value == '-0'
      [:ok, value: value_i]
    else
      [:error, detail: error]
    end
  end

end
