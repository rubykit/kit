class Kit::Contract::Changeset::Validations::NonEmptyArray < Kit::Contract::Changeset::Validations::WithError

  def self.default_error
    'Please select at least one value.'
  end

  def self.call(value:, error: nil, **)
    error ||= default_error

    if value.is_a?(::Array) && value.size > 0
      [:ok]
    else
      [:error, detail: error]
    end
  end

end
