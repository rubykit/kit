module ActiveAdmin
  module ViewHelpers
    module DisplayHelper

      def format_attribute(resource, attr)
        value = find_value resource, attr

        if attr == :id
          link = auto_link(resource, value)
          Arbre::Context.new { code link }
        elsif value.is_a?(Arbre::Element)
          value
        elsif boolean_attr?(resource, attr, value)
          Arbre::Context.new { status_tag value }
        else
          if value == nil && (association = resource.class.try :reflect_on_association, attr) && (value = resource[association.foreign_key])
            Arbre::Context.new { code "DELETED #{attr} #{value}" }
          else
            pretty_format value
          end
        end
      end

      # Attempts to create a human-readable string for any object
      def pretty_format(object)
        case object
        when String, Numeric, Symbol, Arbre::Element
          object.to_s
        when Date, Time, DateTime
          Arbre::Context.new { code I18n.localize object, format: ActiveAdmin.application.localize_format }
        else
          if defined?(::ActiveRecord) && object.is_a?(ActiveRecord::Base) ||
             defined?(::Mongoid)      && object.class.include?(Mongoid::Document)
            auto_link object
          else
            display_name object
          end
        end
      end


    end
  end
end