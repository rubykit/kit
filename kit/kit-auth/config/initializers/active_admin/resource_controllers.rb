module ActiveAdmin::Resource::Controllers

  def controller_name
    module_path = namespace.settings.controllers_path || namespace.module_name
    [module_path, resource_name.plural.camelize + "Controller"].compact.join('::')
  end

end
