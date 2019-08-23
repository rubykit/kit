require 'kit/domain'

module Kit
  module Auth
    class Engine < ::Rails::Engine

      Kit::Domain.config_engine(
        context:   self,
        namespace: Kit::Auth,
        file:      __FILE__,
      )

      initializer "kit-auth.view_helpers" do
        ActionView::Base.send :include, Kit::Auth::Helpers::ViewHelpers
      end

=begin
      initializer "web_app.assets.precompile" do |app|
        app.config.assets.precompile += %w( kit-active-admin.js kit-active-admin.css )
      end
=end

    end
  end
end
