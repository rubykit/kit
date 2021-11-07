class Kit::Auth::Models::Read::UserOauthSecret < Kit::Auth::Models::ReadRecord

  include Kit::Auth::Models::Base::UserOauthSecret

  belongs_to :user_oauth_identity,
    class_name:  'Kit::Auth::Models::Read::UserOauthIdentity',
    foreign_key: :user_oauth_identity_id

end
