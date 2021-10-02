class ActiveAdmin::Namespace

  def route_prefix
    puts "ROUTE_PREFIX: #{ root? }|#{ settings.scope_path }|#{ @name }"
    root? ? nil : (settings.scope_path || @name)
    @name
  end

end