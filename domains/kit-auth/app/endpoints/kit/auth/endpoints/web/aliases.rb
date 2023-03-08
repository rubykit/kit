# All Web endpoints aliases declarations.
module Kit::Auth::Endpoints::Web::Aliases

  def self.register_aliases
    Kit::Auth::Endpoints::Web::Aliases::AccessTokens.register_aliases
    Kit::Auth::Endpoints::Web::Aliases::CurrentUser.register_aliases
    Kit::Auth::Endpoints::Web::Aliases::RequestUser.register_aliases
    Kit::Auth::Endpoints::Web::Aliases::SessionUser.register_aliases
  end

end
