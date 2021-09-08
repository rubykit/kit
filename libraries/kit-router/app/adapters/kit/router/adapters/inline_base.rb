module Kit::Router::Adapters::InlineBase

  def self.call(endpoint:, params:)
    Kit::Organizer.call(
      list: [
        self.method(:create_router_request),
        endpoint,
      ],
      ctx:  {
        params: params,
      },
    )
  end

  def self.cast(endpoint:, params:)
    call(endpoint: endpoint, params: params)

    [:ok]
  end

  def self.create_router_request(params:)
    router_request = Kit::Router::Models::RouterRequest.new(params: params)

    [:ok, router_request: router_request]
  end

end
