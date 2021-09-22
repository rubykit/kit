require_relative 'base_table'

class Kit::Auth::Admin::Tables::OauthAccessToken < Kit::Auth::Admin::Tables::BaseTable

  def attributes_for_all
    base_attributes.merge(
      created_at:        nil,
      updated_at:        nil,
      user:              :model_verbose,
      oauth_application: :model_verbose,
      token:             :code,
      active:            [nil, ->(el) { el.active? }],
      refresh_token:     :code,
      expires_in:        :code,
      scopes:            :code,
      revoked_at:        nil,
      last_urm:          [:model, ->(el) { el.last_request_metadata }],
    )
  end

  def attributes_for_index
    attributes_for_all.slice(:id, :created_at, :user, :oauth_application, :token, :active, :expires_in, :revoked_at, :scopes, :last_urm)
  end

  def attributes_for_list
    attributes_for_index
  end

  def attributes_for_show
    attributes_for_all
  end

end
