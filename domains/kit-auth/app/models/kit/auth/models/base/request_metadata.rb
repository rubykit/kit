module Kit::Auth::Models::Base::RequestMetadata

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
      :utm,
      :data,

      :user_id,
    ]
  end

  def user_agent
    data['user_agent']
  end

end
