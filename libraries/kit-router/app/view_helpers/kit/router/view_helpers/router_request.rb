# View helper to make kit router_request available in views (including layouts)
module Kit::Router::ViewHelpers::RouterRequest

  def router_request
    request.instance_variable_get(:@kit_router_request)
  end

end
