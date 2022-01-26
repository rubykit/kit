if defined?(::ActiveAdmin)

  ::ActiveAdmin.setup do |config|

    config.namespace :kit_auth do |ns|
      ns.route_prefix = 'admin'
    end

    config.route_prefix = 'admin'
    config.root_to      = 'kit/auth/users#index'

    config.site_title   = "Kit::Auth - Default Admin"

    config.display_name_methods = [:model_verbose_name]

    config.authentication_method = :authenticate_admin_user!
    config.current_user_method   = :current_admin_user

    config.logout_link_path   = ->(*) { Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|sign_out|destroy') }
    config.logout_link_method = :delete
    #config.logout_link_method = ->(*) { Kit::Router::Adapters::Http::Mountpoints.verb(id: 'web|users|sign_out|destroy') }

    config.comments      = false
    config.comments_menu = false
    config.batch_actions = false

    config.filter_attributes = [:hashed_secret, :password, :password_confirmation]

    config.localize_format = :long

    config.include_default_association_filters = false
  end

  ActiveAdmin::BaseController.class_eval do
    helper ActiveAdmin::ViewsHelper

    # Note: redundant with dummy WebController in this case, but the declaration happens way later and does not work for the following Admin Concern.
    include Kit::Router::Controllers::Concerns::RouterConn
    include Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

    include Kit::Auth::DummyAppContainer::Controllers::Web::Concerns::Admin
  end

end