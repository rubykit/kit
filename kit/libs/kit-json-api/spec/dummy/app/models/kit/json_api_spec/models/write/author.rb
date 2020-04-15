class Kit::JsonApiSpec::Models::Write::Author < Kit::JsonApiSpec::Models::WriteRecord

  self.table_name = 'kit_json_api_spec_authors'

  self.whitelisted_columns = [
    :id,
    :created_at,
    :updated_at,
    :name,
    :date_of_birth,
    :date_of_death,
  ]

  has_many :books, {
    class_name:  'Kit::JsonApiSpec::Models::Write::Books',
    foreign_key: 'kit_json_api_spec_author_id',
  }

  has_many :photos, {
    class_name: 'Kit::JsonApiSpec::Models::Write::Photo',
    as:         :imageable,
  }

end
