module Kit::Auth::Models::Write
  class OauthAccessToken < Kit::Auth::Models::WriteRecord

    belongs_to :oauth_application,
               class_name: 'Kit::Auth::Models::Write::OauthApplication',
               foreign_key: 'application_id'

    belongs_to :user,
               class_name: 'Kit::Auth::Models::Write::User',
               foreign_key: 'resource_owner_id'

    belongs_to :last_user_request_metadata,
               class_name: 'Kit::Auth::Models::Write::UserRequestMetadata'

  end
end
