class Kit::Auth::Models::Write::User < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::User

  validates :email, presence: true

  has_many :user_secrets,
    class_name:  'Kit::Auth::Models::Write::UserSecret',
    foreign_key: :user_id

  has_many :user_oauth_identities,
    class_name:  'Kit::Auth::Models::Write::UserOauthIdentity',
    foreign_key: :user_id

  def primary_user_email
    Kit::Auth::Models::Write::UserEmail.find(self.id)
  end

end
