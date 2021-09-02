class Kit::Contract::Changeset::Validations::CastToDateTime < Kit::Contract::Changeset::Validations::WithError

  def self.default_error
    'Invalid date.'
  end

  def self.call(value:, format:, error: nil, **)
    error ||= default_error

    begin
      date = DateTime.strptime(value, format)
      [:ok, value: date]
    rescue Date::Error
      [:error, detail: error]
    end
  end

end
