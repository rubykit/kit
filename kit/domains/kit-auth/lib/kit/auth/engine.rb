require 'kit/domain'

module Kit
  module Auth
    class Engine < ::Rails::Engine

      Kit::Domain.config_engine(
        context:   self,
        namespace: Kit::Auth,
        file:      __FILE__,
      )

=begin
      initializer "web_app.assets.precompile" do |app|
        app.config.assets.precompile += %w( kit-active-admin.js kit-active-admin.css )
      end
=end

=begin
      config.to_prepare do
        ApplicationController.helper(Kit::Auth::Helpers::CurrentUserHelper)
      end
=end

    end
  end
end
