module Kit::Auth::Models::Read
  class User < Kit::Auth::Models::ReadRecord
    #fields(:id, :email, :password_encrypted)

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

  end
end
