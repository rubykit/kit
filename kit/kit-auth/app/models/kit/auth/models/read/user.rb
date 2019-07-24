module Kit::Auth::Models::Read
  class User < Kit::Auth::Models::ReadRecord

    has_many :access_grants,
             class_name: 'Doorkeeper::AccessGrant',
             foreign_key: :resource_owner_id

    has_many :access_tokens,
             class_name: 'Doorkeeper::AccessToken',
             foreign_key: :resource_owner_id

    #fields(:id, :email, :password_encrypted)
  end
end
