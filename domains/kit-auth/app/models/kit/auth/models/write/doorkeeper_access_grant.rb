require 'doorkeeper/orm/active_record/mixins/access_grant'

class Kit::Auth::Models::Write::DoorkeeperAccessGrant < Kit::Auth::Models::WriteRecord

  include Doorkeeper::Orm::ActiveRecord::Mixins::AccessGrant

  self.table_name = 'user_secrets'

  self.columns_whitelisting = false

  default_scope { where(category: 'oauth_access_grant') }

  jsonb_accessor :data, {
    redirect_uri: :string,
  }

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
