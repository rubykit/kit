if defined?(::ActiveAdmin)

  ::ActiveAdmin.setup do |config|
    config.namespace :kit_auth do |admin|
      #admin.site_title = 'KitAuth - Admin'
      #admin.site_title_link = kit_admin.root_path
      #admin.authentication_method = :authenticate_user
      #admin.authentication_method = false
      #admin.current_user_method = :session_user

      admin.scope_as         = 'kit_auth'
      admin.scope_path       = 'kit_auth'
      admin.scope_module     = 'kit/auth/admin'

      admin.controllers_path = 'Kit::Auth::Admin'

      admin.comments      = false
      admin.comments_menu = false

      #admin.logout_link_path = Kit::Auth::Routes.web_signout_path
      #admin.logout_link_path   = '/kit-auth/web/signout'
      #admin.logout_link_method = :delete

      admin.root_to = 'users#index'
    end
  end

  ActiveAdmin::BaseController.class_eval do
    include Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

    helper ActiveAdmin::ViewsHelper
  end

end
