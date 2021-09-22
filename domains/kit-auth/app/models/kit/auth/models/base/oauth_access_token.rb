module Kit::Auth::Models::Base::OauthAccessToken

  extend ActiveSupport::Concern

  included do
    self.table_name = 'oauth_access_tokens'

    acts_as_paranoid

    self.whitelisted_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,
      :resource_owner_id,
      :application_id,
      :token,
      :scopes,
      :expires_in,
      :revoked_at,
      :refresh_token,
      #:last_request_metadata_id,
    ]
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
