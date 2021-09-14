# ViewHelper to deal with routing.
module Kit::Router::ViewHelpers::HttpRoutes

  def router_url(id:, params: {})
    Kit::Router::Adapters::Http::Mountpoints.url(id: id, params: params)
  end

  def router_path(id:, params: {})
    Kit::Router::Adapters::Http::Mountpoints.path(id: id, params: params)
  end

  def router_verb(id:)
    Kit::Router::Adapters::Http::Mountpoints.verb(id: id).downcase
  end

  def router_link_to(id:, params: {}, html: {}, full_url: nil, request: nil, active: nil, &block)
    if full_url == true
      url  = router_url(id: id, params: params)
    else
      url  = router_path(id: id, params: params)
    end
    verb   = router_verb(id: id)

    active = (active == nil) ? true : active

    html[:href] = url

    if verb.to_sym != :get
      html['data-method'] = verb
    end

    if active && Kit::Router::Adapters::Http::Mountpoints.request_route?(request: request, id: id)
      html[:class] ||= ''
      html[:class] << ' active'
    end

    content_tag('a', url, html, &block)
  end

end
