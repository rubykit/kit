module Kit::Auth::Models::Write
  class User < Kit::Auth::Models::WriteRecord
    #fields(:id, :email, :password_encrypted)
    acts_as_paranoid

    has_many :oauth_access_grants,
             class_name: 'Kit::Auth::Models::Read::OauthAccessGrant',
             foreign_key: :resource_owner_id

    has_many :oauth_access_tokens,
             class_name: 'Kit::Auth::Models::Read::OauthAccessToken',
             foreign_key: :resource_owner_id

    validates :email, presence: true

  end
end
