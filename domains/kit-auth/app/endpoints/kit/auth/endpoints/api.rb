# All Api endpoints.
module Kit::Auth::Endpoints::Api

  def self.register_endpoints
    Kit::Auth::Endpoints::Api::Aliases.register_aliases
    Kit::Auth::Endpoints::Api::Index.register_endpoints
    Kit::Auth::Endpoints::Api::Show.register_endpoints
  end

end
