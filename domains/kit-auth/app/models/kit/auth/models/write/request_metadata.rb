module Kit::Auth::Models::Write
  class RequestMetadata < Kit::Auth::Models::WriteRecord

    self.table_name = 'request_metadata'

    acts_as_paranoid

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
      class_name: 'Kit::Auth::Models::Write::User',
      optional:   true

  end
end
