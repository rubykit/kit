module Kit::Auth::Models::Write
  class User < Kit::Auth::Models::WriteRecord
    acts_as_paranoid

    self.whitelisted_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,
      :email,
      :hashed_secret,
      :confirmed_at,
    ]

    has_many :oauth_access_grants,
             class_name: 'Kit::Auth::Models::Write::OauthAccessGrant',
             foreign_key: :resource_owner_id

    has_many :oauth_access_tokens,
             class_name: 'Kit::Auth::Models::Write::OauthAccessToken',
             foreign_key: :resource_owner_id

    validates :email, presence: true

    def model_verbose_name
      "#{model_log_name}|#{email}"
    end

  end
end
