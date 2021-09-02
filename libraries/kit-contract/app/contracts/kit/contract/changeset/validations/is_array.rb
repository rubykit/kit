class Kit::Contract::Changeset::Validations::IsArray < Kit::Contract::Changeset::Validations::WithError

  def self.default_error
    'Invalid date.'
  end

  def self.call(value:, error: nil, **)
    error ||= default_error

    if value.is_a?(::Array)
      [:ok]
    else
      [:error, detail: error]
    end
  end

end
