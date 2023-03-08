# All Api endpoints aliases declarations.
module Kit::Auth::Endpoints::Api::Aliases

  def self.register_aliases
    Kit::Auth::Endpoints::Api::Aliases::RequestUser.register_aliases
  end

end
