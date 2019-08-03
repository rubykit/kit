module Kit::Auth::Models::Write
  class UserRequestMetadata < Kit::Auth::Models::WriteRecord
    #fields(:id, :email, :password_encrypted)
    acts_as_paranoid

    belongs_to :user,
               class_name: 'Kit::Auth::Models::Write::User'

  end
end
