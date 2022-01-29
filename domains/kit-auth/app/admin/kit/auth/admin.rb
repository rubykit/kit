module Kit::Auth::Admin

  def self.register_namespace(**args)
    defaults = {
      namespace:        :kit_auth,
      scope_as:         'kit_auth',
      scope_path:       'kit_auth',
      scope_module:     'kit/auth/admin',
      controllers_path: 'Kit::Auth::Admin',
      root_to:          'auth_users#index',
    }

    # NOTE: not ideal, only way to allow `nil` as a value cleanly?
    opts = defaults
      .map { |k, v| [k, args.key?(k) ? args[k] : v]  }
      .to_h

    Kit::Admin::Services::ActiveAdmin.register_namespace(**opts)

    [:ok]
  end

  def self.register_resources(namespace: nil)
    list = [
      Kit::Auth::Admin::Application,
      Kit::Auth::Admin::RequestMetadata,
      Kit::Auth::Admin::User,
      Kit::Auth::Admin::UserOauthIdentity,
      Kit::Auth::Admin::UserOauthSecret,
      Kit::Auth::Admin::UserSecret,
    ]

    list.each do |el|
      el.send(:register_resource, namespace: namespace)
    end

    [:ok]
  end

  def self.setup_tables
    Kit::ActiveAdmin::Table.class_eval do
      include Kit::Auth::Routes
    end
  end

end
