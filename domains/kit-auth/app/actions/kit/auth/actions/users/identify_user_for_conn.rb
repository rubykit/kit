module Kit::Auth::Actions::Users::IdentifyUserForConn

  # TODO: add contract on router_conn / cookies (based on needed access)
  #Contract Hash => [Symbol, KeywordArgs[user: Any]]
  def self.call(router_conn:, application:)

    _status, ctx = Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::IdentifyUser,
        self.method(:export_current_user_to_router_conn),
      ],
      ctx:  {
        router_conn: router_conn,
        application: application,
      },
    )

    if ctx[:errors]
      [:error, user: nil, errors: ctx[:errors]]
    else
      [:ok, ctx.slice(:user, :access_token)]
    end
  end

  def self.export_current_user_to_router_conn(router_conn:, access_tokens:)
    router_conn.metadata[:current_user_resolved] = true

    if access_tokens[:session]
      router_conn.metadata[:session_user_access_token] = access_tokens[:session]
      router_conn.metadata[:session_user]              = access_tokens[:session].user
    end

    if access_tokens[:request]
      router_conn.metadata[:request_user_access_token] = access_tokens[:request]
      router_conn.metadata[:request_user]              = access_tokens[:request].user
    end

    [:ok, router_conn: router_conn]
  end

end
