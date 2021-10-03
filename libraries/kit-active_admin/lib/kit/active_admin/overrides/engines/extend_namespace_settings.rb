# Sent to Rails router `scope` when mounting.
ActiveAdmin::NamespaceSettings.register :scope_as,         nil
ActiveAdmin::NamespaceSettings.register :scope_module,     nil
ActiveAdmin::NamespaceSettings.register :scope_path,       nil

# If the admins are mounted in a namespace now known by ActiveAdmin, the routes helper prefix needs to be set.
ActiveAdmin::NamespaceSettings.register :route_prefix,     nil

# The namespace admin classes live in.
ActiveAdmin::NamespaceSettings.register :controllers_path, nil

#ActiveAdmin::NamespaceSettings.register :url_helpers,      nil
