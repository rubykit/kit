class ActiveAdmin::Resource::Routes::RouteBuilder

  def routes
    resource.namespace.settings.url_helpers
  end

end