module Kit::Domain::Models::Base::RequestMetadata

  extend ActiveSupport::Concern

  included do
    self.table_name = 'request_metadata'

    acts_as_paranoid

    self.allowed_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,
      :ip,
      :user_agent,
      :utm,
    ]
  end

end
