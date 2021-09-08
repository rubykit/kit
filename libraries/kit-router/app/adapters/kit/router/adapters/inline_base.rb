module Kit::Router::Adapters::InlineBase

  def self.call(router_request:)
    Kit::Organizer.call(
      list: [
        router_request[:endpoint][:callable],
      ],
      ctx:  {
        router_request: router_request,
      },
    )
  end

  def self.cast(router_request:)
    call(router_request: router_request)

    [:ok]
  end

end
