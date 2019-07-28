class ActiveAdmin::Router

  private

  def define_namespace(config)
    options = config.namespace.route_options.dup
    options.merge!({
      as:     config.namespace.scope_module,
      path:   config.namespace.scope_path,
      module: config.namespace.scope_module,
    })
    router.scope options do
      define_routes(config)
    end
  end

end
