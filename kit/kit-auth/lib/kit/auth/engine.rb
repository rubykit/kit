module Kit
  module Auth
    class Engine < ::Rails::Engine
      isolate_namespace Kit::Auth

      config.assets.paths << File.expand_path("../../../../app/cells", __FILE__)

=begin
      config.to_prepare do
        ApplicationController.helper(Kit::Auth::Helpers::CurrentUserHelper)
      end
=end

    end
  end
end
