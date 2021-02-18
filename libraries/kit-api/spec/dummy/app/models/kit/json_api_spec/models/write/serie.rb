class Kit::JsonApiSpec::Models::Write::Serie < Kit::JsonApiSpec::Models::WriteRecord # rubocop:disable Style/Documentation

  self.table_name = 'kit_json_api_spec_series'

  self.whitelisted_columns = [
    :id,
    :created_at,
    :updated_at,
    :title,
  ]

  has_many(:photos,
    class_name: 'Kit::JsonApiSpec::Models::Write::Photo',
    as:         :imageable,
  )

  has_many(:books,
    class_name: 'Kit::JsonApiSpec::Models::Write::Books',
  )

end
