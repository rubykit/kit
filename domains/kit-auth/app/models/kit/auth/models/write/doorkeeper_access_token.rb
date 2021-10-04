require 'doorkeeper/orm/active_record/mixins/access_token'

class Kit::Auth::Models::Write::DoorkeeperAccessToken < Kit::Auth::Models::WriteRecord

  include Doorkeeper::Orm::ActiveRecord::Mixins::AccessToken

  self.table_name = 'user_secrets'

  self.columns_allowlist = false

  default_scope { where(category: 'oauth_access_grant') }

  def self.rebind_columns
    {
      user:    :resource_owner,
      user_id: :resource_owner_id,
      secret:  :token,
    }
  end

  rebind_columns.each { |k, d| alias_attribute(d, k) }

  def where(*args)
    if args.first.is_a?(Hash)
      hash = args.first

      self.class.rebind_columns.each { |kit, doorkeeper| hash[doorkeeper] = hash.delete(kit) }
    end

    super(*args)
  end

end
