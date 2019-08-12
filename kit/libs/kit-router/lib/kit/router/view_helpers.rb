module Kit::Router
  module ViewHelpers

    def router_path(id:, params: {})
      Kit::Router.path(id: id, params: params)
    end

    def router_verb(id:)
      Kit::Router.verb(id: id).downcase
    end

    def router_link_to(id:, params: {}, html: {}, &block)
      url  = router_path(id: id, params: params)
      verb = router_verb(id: id)

      html[:href] = url

      if verb.to_sym != :get
        html['data-method'] = verb
      end

      content_tag('a', url, html, &block)
    end

  end
end