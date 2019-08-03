module Kit::Auth::Models::Read
  class UserRequestMetadata < Kit::Auth::Models::ReadRecord
    #fields(:id, :email, :password_encrypted)
    acts_as_paranoid

    belongs_to :user,
               class_name: 'Kit::Auth::Models::Read::User'

  end
end
