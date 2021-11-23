module Kit::Auth::Services::Oauth

  # List of allowed OAuth providers.
  def self.providers(oauth_store: nil)
    oauth_store ||= default_store

    oauth_store[:providers]
  end

  # Helper for Omniauth request path
  def self.omniauth_strategy_path(omniauth_strategy_name:)
    "#{ OmniAuth.config.path_prefix }/#{ omniauth_strategy_name }"
  end

  # Helper for Omniauth request route
  def self.omniauth_strategy_url(omniauth_strategy_name:)
    "#{ Kit::Router::Adapters::Http::Mountpoints.base_url }#{ omniauth_strategy_path(omniauth_strategy_name: omniauth_strategy_name) }"
  end

  # ### Example
  #
  # ```ruby
  # {
  #   providers: [
  #     {
  #       external_name:     :facebook,     # External name of the provider, used in routes.
  #       omniauth_strategy: :facebook_web, # The name of the registered Omniauth Strategy.
  #       internal_name:     :facebook ,    # The internal name of the provider that will be persisted.
  #       group:             :web,          # Extra info.
  #     },
  #   ],
  # }
  # ```
  def self.create_store
    {
      providers: [],
    }
  end

  def self.default_store
    @default_store ||= create_store
  end

end
