require_relative 'base_table'

class Kit::Auth::Admin::Tables::OauthAccessToken < Kit::Auth::Admin::Tables::BaseTable

  def attributes_for_all
    base_attributes.merge(
      created_at:        nil,
      updated_at:        nil,
      user:              :model_verbose,
      oauth_application: :model_verbose,
      token:             :code,
      refresh_token:     :code,
      expires_in:        nil,
      scopes:            :code,
      revoked_at:        nil,
      last_urm:          [:model, ->(el) { el.last_user_request_metadata } ],
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