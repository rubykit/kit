require 'doorkeeper/orm/active_record/redirect_uri_validator'
require 'doorkeeper/orm/active_record/mixins/application'

class Kit::Auth::Models::Write::DoorkeeperApplication < Kit::Auth::Models::WriteRecord

  include ::Doorkeeper::Orm::ActiveRecord::Mixins::Application

  self.table_name = 'applications'

  self.columns_whitelisting = false

  jsonb_accessor :data, {
    secret:       :string,
    redirect_uri: :string,
    confidential: [:boolean, default: true],
  }

end
