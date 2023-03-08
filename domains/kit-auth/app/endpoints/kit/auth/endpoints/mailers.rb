# All Mailers endpoints.
module Kit::Auth::Endpoints::Mailers

  def self.register_endpoints
    Kit::Auth::Endpoints::Mailers::Users.register_endpoints
  end

end
