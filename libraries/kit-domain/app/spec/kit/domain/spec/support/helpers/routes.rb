module Kit::Domain::Spec::Support::Helpers::Routes

  # Helper to get the router path
  def route_id_to_path(id:, params: nil)
    params ||= {}

    Kit::Router::Adapters::Http::Mountpoints.path(id: id, params: params)
  end

  # Helper to access POST / PATCH / PUT / DELETE routes through the form hack.
  def visit_route_id(id:, params: nil)
    params ||= {}

    verb = Kit::Router::Adapters::Http::Mountpoints.verb(id: id)
    path = Kit::Router::Adapters::Http::Mountpoints.path(id: id, params: params)

    if verb == :get
      visit path
    else
      url = route_id_to_path(id: 'specs|link_to', params: {
        method: verb,
        url:    path,
      },)

      visit url

      assert_current_path url

      find("input[type='submit']").click
    end
  end

end
