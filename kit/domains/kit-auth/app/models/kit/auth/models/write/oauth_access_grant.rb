module Kit::Auth::Models::Write
  class OauthAccessGrant < Kit::Auth::Models::WriteRecord

    belongs_to :oauth_application,
               class_name: 'Kit::Auth::Models::Write::OauthApplication',
               foreign_key: 'application_id'

    belongs_to :user,
               class_name: 'Kit::Auth::Models::Write::User',
               foreign_key: 'resource_owner_id'

  end
end
