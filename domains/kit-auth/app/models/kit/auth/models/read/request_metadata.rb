module Kit::Auth::Models::Read
  class RequestMetadata < Kit::Auth::Models::ReadRecord

    self.table_name = 'request_metadata'

    self.whitelisted_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,
      :user_id,
      :ip,
      :user_agent,
      :utm,
    ]

    belongs_to :user,
      class_name: 'Kit::Auth::Models::Read::User'

  end
end
