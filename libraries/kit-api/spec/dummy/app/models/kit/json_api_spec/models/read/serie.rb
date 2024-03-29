class Kit::JsonApiSpec::Models::Read::Serie < Kit::JsonApiSpec::Models::ReadRecord # rubocop:disable Style/Documentation

  self.table_name = 'kit_json_api_spec_series'

  self.allowed_columns = [
    :id,
    :created_at,
    :updated_at,
    :title,
  ]

  has_many(:photos,
    class_name: 'Kit::JsonApiSpec::Models::Read::Photo',
    as:         :imageable,
  )

  has_many(:books,
    class_name: 'Kit::JsonApiSpec::Models::Read::Books',
  )

end
