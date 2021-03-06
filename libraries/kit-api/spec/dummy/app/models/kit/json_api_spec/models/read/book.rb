class Kit::JsonApiSpec::Models::Read::Book < Kit::JsonApiSpec::Models::ReadRecord # rubocop:disable Style/Documentation

  self.table_name = 'kit_json_api_spec_books'

  self.whitelisted_columns = [
    :id,
    :created_at,
    :updated_at,
    :kit_json_api_spec_author_id,
    :kit_json_api_spec_serie_id,
    :title,
    :date_published,
  ]

  belongs_to(:author,
    class_name:  'Kit::JsonApiSpec::Models::Read::Author',
    foreign_key: 'kit_json_api_spec_author_id',
  )

  belongs_to(:serie,
    class_name:  'Kit::JsonApiSpec::Models::Read::Serie',
    foreign_key: 'kit_json_api_spec_serie_id',
    optional:    true,
  )

  has_many(:chapters,
    class_name:  'Kit::JsonApiSpec::Models::Read::Chapter',
    foreign_key: 'kit_json_api_spec_book_id',
  )

  has_many(:photos,
    class_name: 'Kit::JsonApiSpec::Models::Read::Photo',
    as:         :imageable,
  )

  has_and_belongs_to_many(:stores,
    class_name:              'Kit::JsonApiSpec::Models::Read::Store',
    join_table:              'kit_json_api_spec_books_stores',
    foreign_key:             'kit_json_api_spec_book_id',
    association_foreign_key: 'kit_json_api_spec_store_id',
  )

end
