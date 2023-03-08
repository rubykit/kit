# All Events endpoints.
module Kit::Auth::Endpoints::Events

  def self.register_endpoints
    Kit::Auth::Endpoints::Events::Users.register_endpoints
  end

end
