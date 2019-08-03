module Kit::Auth::Models::Write
  class OauthIdentity < Kit::Auth::Models::WriteRecord

    belongs_to :user,
               class_name: 'Kit::Auth::Models::Write::User'

  end
end
