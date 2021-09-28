# Formatting helpers for `ActiveModel`
#
# ### References
# - https://api.rubyonrails.org/classes/ActiveModel/Errors.html
module Kit::Error::Format::ActiveModel

  # Convert `ActiveModel` errors output to `Kit` errors output
  def self.from(errors)
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
