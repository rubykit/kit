module ActiveAdmin
  module Views
    module Pages
      class Base < Arbre::HTML::Document

        def body_classes
          Arbre::HTML::ClassList.new [
            params[:action],
            params[:controller].tr('/', '_'),
            'active_admin', 'logged_in',
            active_admin_namespace.name.to_s + '_namespace',
            "env_#{Rails.env}",
          ]
        end

      end
    end
  end
end