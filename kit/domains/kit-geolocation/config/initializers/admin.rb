::ActiveAdmin.setup do |config|

  config.namespace :kit_geolocation_admin do |admin|
    admin.site_title = 'KitGeolocation - Admin'
    admin.authentication_method = false
    admin.current_user_method   = nil

    admin.scope_path       = 'admin'
    admin.scope_module     = 'admin'

    admin.controllers_path = 'Kit::Geolocation::Admin'
    admin.url_helpers      = Kit::Geolocation::Routes

    admin.comments = false
    admin.comments_menu = false

    admin.root_to = 'countries#index'
  end

  config.display_name_methods = [:model_verbose_name]

  config.comments = false
  config.comments_menu = false

  config.batch_actions = false

  config.localize_format = :long


  config.include_default_association_filters = false
end

module Kit::Geolocation::Admin
end