module Helpers::Routes

  def route_uid_to_path(route_uid)
    Kit::Router::Services::Adapters::Http::Mountpoints.path(id: route_uid)
  end

end
