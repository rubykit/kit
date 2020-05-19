# Ignore this namespace definition.
module Kit

  # Shortcut to generate proper return values without the boilerplate.
  #
  # Note that this a method that shadows the namespace.
  #
  # Examples
  # ```ruby
  # irb> Kit::Error("Error message")
  # [:error, errors: ["Error message"]]
  # ```
  def self.Error(msg)
    [:error, ErrorCtx(msg)]
  end

  # Shortcut to generate proper ctx return values without the boilerplate.
  #
  # Examples
  # ```ruby
  # irb> Kit::ErrorCtx("Error message")
  # { errors: ["Error message"] }
  # irb> Kit::ErrorCtx(["Error message 1", "Error message 2"])
  # { errors: ["Error message 1", "Error message 2"] }
  # ```
  def self.ErrorCtx(msg)
    if !msg.is_a?(::Array)
      msg = [msg]
    end

    { errors: msg.flatten }
  end

  # Namespace for our error behaviour.
  module Error

    # Current format `[{ attribute: :email, detail: "is already taken" }]`
    #
    # ### References
    # - https://dry-rb.org/gems/dry-validation/
    def self.from_contract(errors)
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

    # ### References
    # - https://api.rubyonrails.org/classes/ActiveModel/Errors.html
    def self.from_active_model(errors)
      if errors.respond_to?(:errors)
        errors = errors.errors
      end
      if errors.respond_to?(:messages)
        errors = errors.messages
      end

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

    # A JSON::API example:
    # ```json
    #   {
    #     "errors": [
    #       {
    #         "status": "422",
    #         "source": { "pointer": "/data/attributes/firstName" },
    #         "title":  "Invalid Attribute",
    #         "detail": "First name must contain at least three characters."
    #       }
    #     ]
    #   }
    # ```
    #
    # ### References
    # - https://jsonapi.org/examples/#error-objects
    def self.to_json_api(errors)
      errors
    end

=begin
    def self.full_message(attribute:, message:)
      return message if attribute == :base
      attr_name = attribute.to_s.tr(".", "_").humanize
      attr_name = @base.class.human_attribute_name(attribute, default: attr_name)
      I18n.t(:"errors.format",
        default:  "%{attribute} %{message}",
        attribute: attr_name,
        message:   message)
    end
=end

  end
end
