module Kit
  module Error
    class << self

      # NOTE: current format [{ attribute: :email, detail: "is already taken" }]

      # LINK: https://dry-rb.org/gems/dry-validation/
      def from_contract(errors)
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

      # LINK: https://api.rubyonrails.org/classes/ActiveModel/Errors.html
      def from_active_model(errors)
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

      # LINK: https://jsonapi.org/examples/#error-objects

=begin
      LINK: https://jsonapi.org/examples/#error-objects
      A JSON::API example:
      ```
        {
          "errors": [
            {
              "status": "422",
              "source": { "pointer": "/data/attributes/firstName" },
              "title":  "Invalid Attribute",
              "detail": "First name must contain at least three characters."
            }
          ]
        }
      ```
=end

      def to_json_api(errors)
        errors
      end


=begin
      def full_message(attribute:, message:)
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
end