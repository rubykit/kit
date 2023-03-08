# All Kit::Auth endpoints
module Kit::Auth::Endpoints

  def self.register_endpoints
    Kit::Auth::Endpoints::Api.register_endpoints
    Kit::Auth::Endpoints::Events.register_endpoints
    Kit::Auth::Endpoints::Mailers.register_endpoints
    Kit::Auth::Endpoints::Web.register_endpoints
  end

end
