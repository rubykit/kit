module Kit::Auth::Models::Read
  class OauthApplication < Kit::Auth::Models::ReadRecord

    self.table_name = 'oauth_applications'

    self.whitelisted_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,
      :name,
      :uid,
      :secret,
      :redirect_uri,
      :scopes,
      :confidential,
    ]

    has_many :oauth_access_grants,
      class_name:  'Kit::Auth::Models::Read::OauthAccessGrant',
      foreign_key: 'application_id'

    has_many :oauth_access_tokens,
      class_name:  'Kit::Auth::Models::Read::OauthAccessToken',
      foreign_key: 'application_id'

    def model_verbose_name
      "#{ model_log_name }|#{ name }"
    end

  end
end
