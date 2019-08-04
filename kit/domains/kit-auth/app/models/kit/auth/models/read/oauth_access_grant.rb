module Kit::Auth::Models::Read
  class OauthAccessGrant < Kit::Auth::Models::ReadRecord


    self.whitelisted_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,
      :resource_owner_id,
      :application_id,
      :token,
      :scopes,
      :expires_in,
      :revoked_at,
      :redirect_uri,
    ]

    belongs_to :oauth_application,
               class_name: 'Kit::Auth::Models::Read::OauthApplication',
               foreign_key: 'application_id'

    belongs_to :user,
               class_name: 'Kit::Auth::Models::Read::User',
               foreign_key: 'resource_owner_id'

  end
end
