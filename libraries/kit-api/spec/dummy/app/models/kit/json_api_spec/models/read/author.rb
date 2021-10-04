class Kit::JsonApiSpec::Models::Read::Author < Kit::JsonApiSpec::Models::ReadRecord # rubocop:disable Style/Documentation

  self.table_name = 'kit_json_api_spec_authors'

  self.allowed_columns = [
    :id,
    :created_at,
    :updated_at,
    :name,
    :date_of_birth,
    :date_of_death,
  ]

  has_many(:books,
    class_name:  'Kit::JsonApiSpec::Models::Read::Books',
    foreign_key: 'kit_json_api_spec_author_id',
  )

  has_many(:photos,
    class_name: 'Kit::JsonApiSpec::Models::Read::Photo',
    as:         :imageable,
  )

end
