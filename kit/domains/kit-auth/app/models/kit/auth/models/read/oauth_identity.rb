module Kit::Auth::Models::Read
  class OauthIdentity < Kit::Auth::Models::ReadRecord


    self.whitelisted_columns = [
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
               class_name: 'Kit::Auth::Models::Read::User'

  end
end
