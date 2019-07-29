module Kit
  module Auth
    class Engine < ::Rails::Engine
      isolate_namespace Kit::Auth

      config.assets.paths << File.expand_path("../../../../app/cells", __FILE__)

      initializer :kit_auth_engine do
        ::ActiveAdmin.application.load_paths += Dir[File.expand_path("../../../../app/admin", __FILE__)]
      end

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
