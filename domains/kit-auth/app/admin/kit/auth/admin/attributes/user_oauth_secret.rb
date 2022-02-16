class Kit::Auth::Admin::Attributes::UserOauthSecret < Kit::Admin::Attributes

  def self.all
    base_attributes.merge(
      user_oauth_identity:  :model_verbose,

      provider_app_id:      :code,

      secret_token:         :boolean,
      secret_refresh_token: :boolean,

      expires_at:           nil,
    )
  end

end
