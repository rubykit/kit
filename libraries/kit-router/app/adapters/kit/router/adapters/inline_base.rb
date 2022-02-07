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
    begin
      call(router_conn: router_conn)
    rescue Exception => e # rubocop:disable Lint/RescueException
      Kit::Error.report_exception(exception: e)
    end

    [:ok]
  end

end
