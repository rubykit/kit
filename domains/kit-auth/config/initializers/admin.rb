if defined?(::ActiveAdmin)

  ::ActiveAdmin.setup do |config|
    config.namespace :kit_auth do |ns|
      ns.scope_as         = 'kit_auth'
      ns.scope_path       = 'kit_auth'
      ns.scope_module     = 'kit/auth/admin'

      ns.controllers_path = 'Kit::Auth::Admin'

      ns.root_to          = 'users#index'
    end
  end

end
