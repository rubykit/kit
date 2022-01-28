class ActiveAdmin::Router

  private

  # Allow to override the way the root_to is mounted through external namespace config.
  #
  # ### References
  # - https://github.com/activeadmin/activeadmin/blob/v2.9.0/lib/active_admin/router.rb#L18
  def define_root_routes
    namespaces.each do |namespace|
      if namespace.root?
        router.root namespace.root_to_options.merge(to: namespace.root_to)
      else
        options = namespace.route_options.dup
        options.merge!({
          as:     namespace.scope_as,
          path:   namespace.scope_path,
          module: namespace.scope_module,
        })

        if !options[:as]
          options = options.except(:as)
        end

        router.scope(options) do
          router.root namespace.root_to_options.merge(to: namespace.root_to, as: :root)
        end
      end
    end
  end

  # Allow to override the way routes are mounted through external namespace config.
  #
  # ### References
  # - https://github.com/activeadmin/activeadmin/blob/v2.9.0/lib/active_admin/router.rb#L108
  def define_namespace(config)
    options = config.namespace.route_options.dup
    options.merge!({
      as:     config.namespace.scope_as,
      path:   config.namespace.scope_path,
      module: config.namespace.scope_module,
    })

    if !options[:as]
      options = options.except(:as)
    end

    router.scope(options) do
      define_routes(config)
    end
  end

end
