module Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

  extend ActiveSupport::Concern

  def kit_auth_resolve_current_user
    kit_router_conn = get_kit_router_conn
    return nil if !kit_router_conn

    Kit::Organizer.call(
      list: [
        [:alias, :web_resolve_current_user],
      ],
      ctx:  {
        router_conn: kit_router_conn,
      },
    )
  end

  def session_user
    kit_router_conn = get_kit_router_conn
    return nil if !kit_router_conn

    @kit_session_user ||= kit_router_conn.metadata[:session_user]

    if !@kit_session_user
      kit_auth_resolve_current_user
      @kit_session_user = kit_router_conn.metadata[:session_user]
    end

    @kit_session_user
  end

  def session_user_access_token
    kit_router_conn = get_kit_router_conn
    return nil if !kit_router_conn

    @kit_session_user_access_token ||= kit_router_conn.metadata[:session_user_access_token]

    if !@kit_session_user_access_token
      kit_auth_resolve_current_user
      @kit_session_user_access_token = kit_router_conn.metadata[:session_user_access_token]
    end

    @kit_session_user_access_token
  end

  def request_user
    kit_router_conn = get_kit_router_conn
    return nil if !kit_router_conn

    @kit_request_user ||= kit_router_conn.metadata[:request_user]

    if !@kit_request_user
      kit_auth_resolve_current_user
      @kit_request_user = kit_router_conn.metadata[:request_user]
    end

    @kit_request_user
  end

  def request_user_access_token
    kit_router_conn = get_kit_router_conn
    return nil if !kit_router_conn

    @kit_request_user_access_token ||= kit_router_conn.metadata[:request_user_access_token]

    if !@kit_request_user_access_token
      kit_auth_resolve_current_user
      @kit_request_user_access_token = kit_router_conn.metadata[:request_user_access_token]
    end

    @kit_request_user_access_token
  end

end
