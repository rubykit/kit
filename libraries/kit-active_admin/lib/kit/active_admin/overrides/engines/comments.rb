# Prevent loading of Comment ressource.
#
# ### References
# - https://github.com/activeadmin/activeadmin/issues/5117
class ActiveAdmin::Namespace

  # ### References
  # - https://github.com/activeadmin/activeadmin/blob/v2.9.0/lib/active_admin/namespace.rb#L65
  def register(resource_class, options = {}, &block)
    if resource_class == ActiveAdmin::Comment && settings.comments == false
      return
    end

    config = find_or_build_resource(resource_class, options)

    # Register the resource
    register_resource_controller(config)
    parse_registration_block(config, &block) if block_given?
    reset_menu!

    # Dispatch a registration event
    ActiveSupport::Notifications.publish ActiveAdmin::Resource::RegisterEvent, config

    # Return the config
    config
  end

end
