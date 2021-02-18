class Kit::JsonApiSpec::Models::Read::Photo < Kit::JsonApiSpec::Models::ReadRecord # rubocop:disable Style/Documentation

  self.table_name = 'kit_json_api_spec_photos'

  self.whitelisted_columns = [
    :id,
    :created_at,
    :updated_at,
    :imageable_id,
    :imageable_type,
    :title,
    :uri,
  ]

  belongs_to(:imageable,
    polymorphic: true,
  )

end
