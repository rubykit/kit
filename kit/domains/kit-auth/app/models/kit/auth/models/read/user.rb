module Kit::Auth::Models::Read
  class User < Kit::Auth::Models::ReadRecord
    self.table_name = 'users'



    self.whitelisted_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,
      :email,
      :hashed_secret,
      :confirmed_at,
    ]

    has_many :oauth_access_grants,
             class_name: 'Kit::Auth::Models::Read::OauthAccessGrant',
             foreign_key: :resource_owner_id

    has_many :oauth_access_tokens,
             class_name: 'Kit::Auth::Models::Read::OauthAccessToken',
             foreign_key: :resource_owner_id

    # For compatibility reasons with Doorkeeper, perfect example
    has_many :access_grants,
             class_name: 'Doorkeeper::AccessGrant',
             foreign_key: :resource_owner_id

    has_many :access_tokens,
             class_name: 'Doorkeeper::AccessToken',
             foreign_key: :resource_owner_id

    def model_verbose_name
      "#{model_log_name}|#{email}"
    end

  end
end
