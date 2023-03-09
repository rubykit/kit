require 'lockbox'

module Kit::Auth::Models::Base::UserOauthSecret

  extend ActiveSupport::Concern

  included do
    self.table_name = 'user_oauth_secrets'

    acts_as_paranoid

    # NOTE: needed for dev mode code reload.
    extend ::Lockbox::Model
    ActiveRecord::Relation.prepend ::Lockbox::Calculations

    has_encrypted :token,         encrypted_attribute: :secret_token
    has_encrypted :refresh_token, encrypted_attribute: :secret_refresh_token

    read_columns = []

    write_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,

      :user_oauth_identity_id,

      :provider_app_id,
      :secret_token,
      :secret_refresh_token,
      :expires_at,
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
