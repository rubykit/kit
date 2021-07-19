require 'doorkeeper/orm/active_record/mixins/access_grant'

module Kit::Auth::Models::Write
  class DoorkeeperAccessGrant < Kit::Auth::Models::WriteRecord

    include Doorkeeper::Orm::ActiveRecord::Mixins::AccessGrant

  end
end
