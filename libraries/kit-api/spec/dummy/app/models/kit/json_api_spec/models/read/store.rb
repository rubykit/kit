class Kit::JsonApiSpec::Models::Read::Store < Kit::JsonApiSpec::Models::ReadRecord # rubocop:disable Style/Documentation

  self.table_name = 'kit_json_api_spec_stores'

  self.allowed_columns = [
    :id,
    :created_at,
    :updated_at,
    :name,
  ]

  has_and_belongs_to_many(:books,
    class_name:              'Kit::JsonApiSpec::Models::Read::Book',
    join_table:              'kit_json_api_spec_books_stores',
    foreign_key:             'kit_json_api_spec_store_id',
    association_foreign_key: 'kit_json_api_spec_book_id',
  )

end
