module Kit::Auth::Models::Write
  class User < Kit::Auth::Models::WriteRecord
    acts_as_paranoid

    validates :email, presence: true

    #fields(:id, :email, :password_encrypted)
  end
end
