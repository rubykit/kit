# Formatting helpers for `DryValidation`
#
# Current format: `[{ attribute: :email, detail: "is already taken" }]`
#
# ### References
# - https://dry-rb.org/gems/dry-validation/
module Kit::Error::Format::DryValidation

  # Convert `DryValidation` errors output to `Kit` errors output
  def self.from(errors)
    if errors.respond_to?(:errors)
      errors = errors.errors
    end

    errors = errors.to_h

    list = []
    errors.each do |attribute, messages|
      messages.each do |message|
        list << {
          attribute: attribute,
          detail:    message,
        }
      end
    end

    list
  end

end
