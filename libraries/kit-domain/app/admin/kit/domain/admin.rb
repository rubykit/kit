module Kit::Domain::Admin

  def self.register_namespace(**args)
    defaults = {
      namespace:        :kit_domain,
      scope_as:         'kit_domain',
      scope_path:       'kit_domain',
      scope_module:     'kit/domain/admin',
      controllers_path: 'Kit::Domain::Admin',
      root_to:          'events#index',
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
      Kit::Domain::Admin::Event,
      Kit::Domain::Admin::RequestMetadata,
    ]

    list.each do |el|
      el.send(:register_resource, namespace: namespace)
    end

    [:ok]
  end

end
