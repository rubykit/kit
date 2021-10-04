module Kit::Auth::Models::Write
  class OauthIdentity < Kit::Auth::Models::WriteRecord

    self.table_name = 'oauth_identities'

    acts_as_paranoid

    self.allowed_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,
      :user_id,
      :provider,
      :uid,
      :token,
      :expires_at,
      :info,
      :extra,
    ]

    belongs_to :user,
      class_name: 'Kit::Auth::Models::Write::User'

  end
end
