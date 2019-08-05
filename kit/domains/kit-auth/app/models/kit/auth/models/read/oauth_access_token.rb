module Kit::Auth::Models::Read
  class OauthAccessToken < Kit::Auth::Models::ReadRecord
    self.table_name = 'oauth_access_tokens'



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
      :refresh_token,
      :last_user_request_metadata_id,
    ]

    belongs_to :oauth_application,
               class_name: 'Kit::Auth::Models::Read::OauthApplication',
               foreign_key: 'application_id'

    belongs_to :user,
               class_name: 'Kit::Auth::Models::Read::User',
               foreign_key: 'resource_owner_id'

    belongs_to :last_user_request_metadata,
               class_name: 'Kit::Auth::Models::Read::UserRequestMetadata'

  end
end
