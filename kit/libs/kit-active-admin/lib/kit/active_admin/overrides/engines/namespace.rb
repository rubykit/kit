class ActiveAdmin::Namespace

  def route_prefix
    root? ? nil : (settings.scope_path || @name)
  end

end