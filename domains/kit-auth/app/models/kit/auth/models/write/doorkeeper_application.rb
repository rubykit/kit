require 'doorkeeper/orm/active_record/redirect_uri_validator'
require 'doorkeeper/orm/active_record/mixins/application'

module Kit::Auth::Models::Write
  class DoorkeeperApplication < Kit::Auth::Models::WriteRecord

    include ::Doorkeeper::Orm::ActiveRecord::Mixins::Application

    self.columns_whitelisting = false

  end
end
