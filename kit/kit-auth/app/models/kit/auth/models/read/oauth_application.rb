module Kit::Auth::Models::Read
  class OauthApplication < Kit::Auth::Models::ReadRecord

    has_many :oauth_access_grants,
             class_name: 'Kit::Auth::Models::Read::OauthAccessGrant',
             foreign_key: 'application_id'

    has_many :oauth_access_tokens,
             class_name: 'Kit::Auth::Models::Read::OauthAccessToken',
             foreign_key: 'application_id'

  end
end
