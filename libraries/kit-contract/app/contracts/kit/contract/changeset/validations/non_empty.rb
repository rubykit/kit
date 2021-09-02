# Check if value is not `.empty?`
class Kit::Contract::Changeset::Validations::NonEmpty < Kit::Contract::Changeset::Validations::WithError

  def self.default_error
    'Please enter a value.'
  end

  def self.call(value:, error: nil, **)
    error ||= default_error

    if value && !value.empty?
      [:ok]
    else
      [:error, detail: error]
    end
  end

end
