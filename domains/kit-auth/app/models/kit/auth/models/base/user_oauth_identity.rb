module Kit::Auth::Models::Base::UserOauthIdentity

  extend ActiveSupport::Concern

  included do
    self.table_name = 'user_oauth_identities'

    acts_as_paranoid

    read_columns = []

    write_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,

      :user_id,

      :provider,
      :provider_uid,

      :data,
    ]

    self.allowed_columns = write_columns + read_columns
  end

  def expired?
    self.expires_at < DateTime.now
  end

  def active?
    !expired?
  end

end
