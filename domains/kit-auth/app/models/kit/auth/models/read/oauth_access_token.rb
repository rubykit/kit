class Kit::Auth::Models::Read::OauthAccessToken < Kit::Auth::Models::ReadRecord

  include Kit::Auth::Models::Base::OauthAccessToken

  belongs_to :oauth_application,
    class_name:  'Kit::Auth::Models::Read::OauthApplication',
    foreign_key: 'application_id'

  belongs_to :user,
    class_name:  'Kit::Auth::Models::Read::User',
    foreign_key: 'resource_owner_id'

  belongs_to :last_request_metadata,
    class_name: 'Kit::Auth::Models::Read::RequestMetadata',
    optional:   true

end
