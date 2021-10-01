module Helpers::Routes

  def route_id_to_path(id:, params: {})
    Kit::Router::Adapters::Http::Mountpoints.path(id: id, params: params)
  end

end
