class Kit::Auth::Models::Write::UserOauthSecret < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::UserOauthSecret

  belongs_to :user_oauth_identity,
    class_name:  'Kit::Auth::Models::Write::UserOauthIdentity',
    foreign_key: :user_oauth_identity_id

end
