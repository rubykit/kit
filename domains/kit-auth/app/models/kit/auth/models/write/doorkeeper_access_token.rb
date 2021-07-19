require 'doorkeeper/orm/active_record/mixins/access_token'

module Kit::Auth::Models::Write
  class DoorkeeperAccessToken < Kit::Auth::Models::WriteRecord

    include Doorkeeper::Orm::ActiveRecord::Mixins::AccessToken

    self.columns_whitelisting = false

  end
end
