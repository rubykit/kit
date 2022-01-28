module Kit::Admin::Services::ActiveAdmin

  def self.register_namespace(namespace:, scope_as: nil, scope_path: nil, scope_module: nil, controllers_path: nil, root_to: nil, url_helpers: nil)
    ::ActiveAdmin.setup do |config|
      config.namespace namespace do |ns|
        # These are for rails router `scope`
        ns.scope_as         = scope_as
        ns.scope_path       = scope_path

        ns.scope_module     = scope_module
        # This is used when declaring resources
        ns.controllers_path = controllers_path

        ns.root_to          = root_to

        if url_helpers
          ns.url_helpers    = url_helpers
        end
      end
    end
  end

end
