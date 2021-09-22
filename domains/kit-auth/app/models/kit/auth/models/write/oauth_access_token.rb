class Kit::Auth::Models::Write::OauthAccessToken < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::OauthAccessToken

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
