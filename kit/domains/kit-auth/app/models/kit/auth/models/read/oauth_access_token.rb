module Kit::Auth::Models::Read
  class OauthAccessToken < Kit::Auth::Models::ReadRecord

    belongs_to :oauth_access_application,
               class_name: 'Kit::Auth::Models::Read::OauthAccessApplication',
               foreign_key: 'application_id'

    belongs_to :user,
               class_name: 'Kit::Auth::Models::Read::User',
               foreign_key: 'resource_owner_id'

  end
end
