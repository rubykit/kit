# Adapter to call endpoints inline (sync).
module Kit::Router::Adapters::InlineBase

  def self.call(router_conn:)
    Kit::Organizer.call(
      list: [
        router_conn[:endpoint][:callable],
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  def self.cast(router_conn:)
    call(router_conn: router_conn)

    [:ok]
  end

end
