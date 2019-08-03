module ActiveAdmin
  module ViewHelpers
    module AutoLinkHelper

      def active_admin_resource_for(klass)
        resource = nil

        if respond_to? :active_admin_namespace
          resource = active_admin_namespace.resource_for klass

          if !resource
            klass_sibling = nil
            if klass&.is_read_class?
              klass_sibling = klass.to_write_class
            elsif klass&.is_write_class?
              klass_sibling = klass.to_read_class
            end

            if klass_sibling
              resource = active_admin_namespace.resource_for klass_sibling
            end
          end
        end

        resource
      end

    end
  end
end
