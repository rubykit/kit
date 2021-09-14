module Kit::Auth::Models::Write
  class OauthAccessToken < Kit::Auth::Models::WriteRecord

    self.table_name = 'oauth_access_tokens'

    acts_as_paranoid

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
      #:last_request_metadata_id,
    ]

    belongs_to :oauth_application,
      class_name:  'Kit::Auth::Models::Write::OauthApplication',
      foreign_key: 'application_id'

    belongs_to :user,
      class_name:  'Kit::Auth::Models::Write::User',
      foreign_key: 'resource_owner_id'

    belongs_to :last_request_metadata,
      class_name: 'Kit::Auth::Models::Write::RequestMetadata',
      optional:   true

  end
end
