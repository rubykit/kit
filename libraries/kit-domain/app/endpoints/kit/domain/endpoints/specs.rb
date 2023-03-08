module Kit::Domain::Endpoints::Specs

  def self.register_endpoints
    Kit::Domain::Endpoints::Specs::Cookies.register_endpoints
    Kit::Domain::Endpoints::Specs::LinkTo.register_endpoint
  end

end
