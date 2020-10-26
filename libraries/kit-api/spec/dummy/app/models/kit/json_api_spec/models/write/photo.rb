class Kit::JsonApiSpec::Models::Write::Photo < Kit::JsonApiSpec::Models::WriteRecord # rubocop:disable Style/Documentation

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

  belongs_to :imageable, {
    polymorphic: true,
  }

end
