module Kit::Auth::Models::Read
  class OauthIdentity < Kit::Auth::Models::ReadRecord

    belongs_to :user,
               class_name: 'Kit::Auth::Models::Read::User'

  end
end
