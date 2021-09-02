module Kit::Contract::Changeset::Validations::DateInPast

  def self.default_error
    'This date should be in the past.'
  end

  def self.call(value:, error: nil, **)
    error ||= default_error

    if value < DateTime.now
      [:ok]
    else
      [:error, detail: error]
    end
  end

end
