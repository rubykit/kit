module Kit::Router::ViewHelpers
  module HttpRoutes

    def router_path(id:, params: {})
      Kit::Router::Services::Adapters::Http::Mountpoints.path(id: id, params: params)
    end

    def router_verb(id:)
      Kit::Router::Services::Adapters::Http::Mountpoints.verb(id: id).downcase
    end

    def router_link_to(id:, params: {}, html: {}, request: nil, &block)
      url  = router_path(id: id, params: params)
      verb = router_verb(id: id)

      html[:href] = url

      if verb.to_sym != :get
        html['data-method'] = verb
      end

      if Kit::Router::Services::Adapters::Http::Mountpoints.is_request_route?(request: request, id: id)
        html[:class] ||= ''
        html[:class] << ' active'
      end

      content_tag('a', url, html, &block)
    end

  end
end