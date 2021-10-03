module ActiveAdmin::Resource::Controllers

  # Add extra namespace config option to resolve the controller namespace.
  #
  # ### References
  # - https://github.com/activeadmin/activeadmin/blob/v2.9.0/lib/active_admin/resource/controllers.rb#L8
  def controller_name
    module_path = namespace.settings.controllers_path || namespace.module_name
    [module_path, resource_name.plural.camelize + "Controller"].compact.join('::')
  end

end
