class ActiveAdmin::Router

  private

  def define_namespace(config)
    options = config.namespace.route_options.dup
   options.merge!({
      as:     config.namespace.scope_module,
      path:   config.namespace.scope_path,
      module: config.namespace.scope_module,
    })

    puts "DEFINE NAMESPACE - #{ config.namespace }"

=begin
    router.namespace module: 'admin', path: 'kit_admin', as: 'kit_auth_admin' do
      router.scope module: 'auth' do
        router.scope module: 'admin' do
          define_routes(config)
        end
      end
    end
=end

    router.scope module: 'admin', path: 'kit_admin', as: 'kit_auth_admin' do
          define_routes(config)
    end

    #router.scope options do
    #  define_routes(config)
    #end
  end

end
