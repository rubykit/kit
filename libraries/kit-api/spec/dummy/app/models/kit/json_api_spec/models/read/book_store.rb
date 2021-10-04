class Kit::JsonApiSpec::Models::Read::BookStore < Kit::JsonApiSpec::Models::ReadRecord # rubocop:disable Style/Documentation

  self.table_name = 'kit_json_api_spec_books_stores'

  self.allowed_columns = [
    :id,
    :created_at,
    :updated_at,
    :kit_json_api_spec_book_id,
    :kit_json_api_spec_store_id,
    :in_stock,
  ]

  belongs_to(:book,
    class_name:  'Kit::JsonApiSpec::Models::Read::Book',
    foreign_key: 'kit_json_api_spec_book_id',
  )

  belongs_to(:store,
    class_name:  'Kit::JsonApiSpec::Models::Read::Store',
    foreign_key: 'kit_json_api_spec_store_id',
  )

end
