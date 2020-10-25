# Helpers methods to display routes & aliases
module Kit::Router::Services::Cli::Mountpoints

  # Get all mountpoints registered with the router
  # TODO: add namespace support.
  def self.list(namespace: nil)
    list = []

    Kit::Router::Services::Store.router_store[:endpoints].each do |_endpoint_uid, endpoint_data|
      routes = endpoint_data.dig(:mountpoints, [:http, :rails])
      next if !routes

      routes.each do |route|
        list << { path: route[1], verb: route[0], uid: endpoint_data[:uid] }
      end
    end

    [:ok, list: list]
  end

end
