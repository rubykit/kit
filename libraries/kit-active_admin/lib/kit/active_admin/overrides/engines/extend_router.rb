class ActiveAdmin::Router

  private

  # Allow to override the way routes are mounted through namespace config.
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

    router.scope options do
      define_routes(config)
    end
  end

end
