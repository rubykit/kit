module Kit::Auth::Models::Base::UserSecret

  extend ActiveSupport::Concern

  included do
    self.table_name = 'user_secrets'

    acts_as_paranoid

    read_columns = []

    write_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,

      :application_id,
      :user_id,
      :category,
      :scopes,
      :secret,
      :secret_strategy,
      :expires_in,
      :revoked_at,
      :data,
    ]

    self.allowed_columns = write_columns + read_columns
  end

  def expired?
    (self.created_at + self.expires_in) < DateTime.now
  end

  def revoked?
    !!self.revoked_at
  end

  def active?
    !revoked? && !expired?
  end

end
