class Kit::Auth::Models::Write::User < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::User

  has_many :user_secrets,
    class_name:  'Kit::Auth::Models::Read::UserSecret',
    foreign_key: :user_id

  validates :email, presence: true

  def primary_user_email
    Kit::Auth::Models::Write::UserEmail.find(self.id)
  end

end
