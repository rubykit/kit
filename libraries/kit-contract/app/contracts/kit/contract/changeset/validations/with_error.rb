# Allow to save a custom error for the validation.
class Kit::Contract::Changeset::Validations::WithError

  attr_reader :error

  def initialize(error:)
    @error = error
  end

  def call(value:, **)
    self.class.call(value: value, error: error)
  end

end
