class Kit::Auth::Models::Write::UserOauthIdentity < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::UserOauthIdentity

  belongs_to :user,
    class_name:  'Kit::Auth::Models::Write::User',
    foreign_key: 'user_id'

  has_many :user_oauth_secrets,
    class_name:  'Kit::Auth::Models::Write::UserOauthSecret',
    foreign_key: :user_oauth_identity_id

  before_save :ensure_data

  protected

  def ensure_data
    self.data ||= {}
  end

end
