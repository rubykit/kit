class Kit::Auth::Admin::Tables::UserOauthSecret < Kit::ActiveAdmin::Table

  def self.attributes_for_all
    base_attributes.merge(
      user_oauth_identity:  :model_verbose,

      provider_app_id:      :code,

      secret_token:         :boolean,
      secret_refresh_token: :boolean,

      expires_at:           nil,
    )
  end

end
