class Kit::Auth::Models::Read::User < Kit::Auth::Models::ReadRecord

  include Kit::Auth::Models::Base::User

  has_many :user_secrets,
    class_name:  'Kit::Auth::Models::Read::UserSecret',
    foreign_key: :user_id

  # For compatibility reasons with Doorkeeper, perfect example
  has_many :access_grants,
    class_name:  'Kit::Auth::Models::Write::DoorkeeperAccessGrant',
    foreign_key: :user_id

  has_many :access_tokens,
    class_name:  'Kit::Auth::Models::Write::DoorkeeperAccessToken',
    foreign_key: :user_id

  def primary_user_email
    Kit::Auth::Models::Read::UserEmail.find(self.id)
  end

end
