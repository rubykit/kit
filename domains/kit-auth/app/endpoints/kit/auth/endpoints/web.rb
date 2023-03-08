# All Web endpoints.
module Kit::Auth::Endpoints::Web

  def self.register_endpoints
    Kit::Auth::Endpoints::Web::Aliases.register_aliases
    Kit::Auth::Endpoints::Web::Users.register_endpoints
  end

end
