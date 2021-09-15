# View helper to make kit router_conn available in views (including layouts)
module Kit::Router::ViewHelpers::RouterConn

  def router_conn
    request.instance_variable_get(:@kit_router_conn)
  end

end
