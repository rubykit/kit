class ActiveAdmin::Page

  # Add extra namespace config option to resolve the controller namespace.
  #
  # ### References
  # - https://github.com/activeadmin/activeadmin/blob/v2.9.0/lib/active_admin/page.rb#L67
  def controller_name
    module_path = namespace.settings.controllers_path || namespace.module_name
    [module_path, camelized_resource_name + "Controller"].compact.join("::")
  end

end
