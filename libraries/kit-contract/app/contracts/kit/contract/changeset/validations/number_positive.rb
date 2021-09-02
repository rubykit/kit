class Kit::Contract::Changeset::Validations::NumberPositive < Kit::Contract::Changeset::Validations::WithError

  def self.default_error
    'Please enter a number greater than 0.'
  end

  def self.call(value:, error: nil, **)
    error ||= default_error

    if value > 0
      [:ok]
    else
      [:error, detail: error]
    end
  end

end
