module Kit::Auth::Helpers::ViewHelpers

  def session_user
    kit_router_conn = request.instance_variable_get(:@kit_router_conn)
    return nil if !kit_router_conn

    kit_router_conn.metadata[:session_user]
  end

  def session_user_access_token
    kit_router_conn = request.instance_variable_get(:@kit_router_conn)
    return nil if !kit_router_conn

    kit_router_conn.metadata[:session_user_access_token]
  end

  def session_user_id_type
    kit_router_conn = request.instance_variable_get(:@kit_router_conn)
    return nil if !kit_router_conn

    kit_router_conn.metadata[:session_user_id_type]
  end

end
