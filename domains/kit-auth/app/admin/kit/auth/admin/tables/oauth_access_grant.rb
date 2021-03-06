require_relative 'base_table'

class Kit::Auth::Admin::Tables::OauthAccessGrant < Kit::Auth::Admin::Tables::BaseTable

  def attributes_for_all
    base_attributes.merge(
      created_at:        nil,
      updated_at:        nil,
      user:              :model_verbose,
      oauth_application: :model_verbose,
      token:             :code,
      expires_in:        nil,
      redirect_uri:      :code,
      scopes:            :code,
      revoked_at:        nil,
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
