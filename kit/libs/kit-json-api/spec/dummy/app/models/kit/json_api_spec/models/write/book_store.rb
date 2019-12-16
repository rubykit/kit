class Kit::JsonApiSpec::Models::Write::BookStore < Kit::JsonApiSpec::Models::WriteRecord
  self.table_name = 'kit_json_api_spec_books_stores'

  self.whitelisted_columns = [
    :id,
    :created_at,
    :updated_at,
    :kit_json_api_spec_book_id,
    :kit_json_api_spec_store_id,
    :in_stock,
  ]

  belongs_to :book,
             class_name:  'Kit::JsonApiSpec::Models::Write::Book',
             foreign_key: 'kit_json_api_spec_book_id'

  belongs_to :store,
             class_name:  'Kit::JsonApiSpec::Models::Write::Store',
             foreign_key: 'kit_json_api_spec_store_id'

end
