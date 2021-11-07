class Kit::Auth::Models::Read::UserOauthIdentity < Kit::Auth::Models::ReadRecord

  include Kit::Auth::Models::Base::UserOauthIdentity

  belongs_to :user,
    class_name:  'Kit::Auth::Models::Read::User',
    foreign_key: 'user_id'

  has_many :user_oauth_secrets,
    class_name:  'Kit::Auth::Models::Read::UserOauthSecret',
    foreign_key: :user_oauth_identity_id

end
