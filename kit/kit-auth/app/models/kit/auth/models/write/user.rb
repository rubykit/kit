module Kit::Auth::Models::Write
  class User < Kit::Auth::Models::WriteRecord
    acts_as_paranoid

    validates :email, presence: true

    has_many :access_grants,
             class_name: 'Doorkeeper::AccessGrant',
             foreign_key: :resource_owner_id,
             dependent: :delete_all

    has_many :access_tokens,
             class_name: 'Doorkeeper::AccessToken',
             foreign_key: :resource_owner_id,
             dependent: :delete_all

    #fields(:id, :email, :password_encrypted)
  end
end
