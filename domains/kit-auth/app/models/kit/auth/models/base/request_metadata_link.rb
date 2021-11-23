module Kit::Auth::Models::Base::RequestMetadataLink

  extend ActiveSupport::Concern

  included do
    self.table_name = 'request_metadata_links'

    acts_as_paranoid

    self.allowed_columns = [
      :id,
      :created_at,
      :updated_at,
      :deleted_at,

      :request_metadata_id,
      :target_object_type,
      :target_object_id,
      :category,
    ]
  end

end
