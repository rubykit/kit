require_relative 'base_table'

class Kit::Auth::Admin::Tables::UserOauthSecret < Kit::Auth::Admin::Tables::BaseTable

  def attributes_for_all
    base_attributes.merge(
      user_oauth_identity:  :model_verbose,

      provider_app_id:      :code,

      secret_token:         :boolean,
      secret_refresh_token: :boolean,

      expires_at:           nil,
    )
  end

  def attributes_for_index
    attributes_for_all
  end

  def attributes_for_list
    attributes_for_index
  end

  def attributes_for_show
    attributes_for_all
  end

end
