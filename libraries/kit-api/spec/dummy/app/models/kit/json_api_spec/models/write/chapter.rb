class Kit::JsonApiSpec::Models::Write::Chapter < Kit::JsonApiSpec::Models::WriteRecord # rubocop:disable Style/Documentation

  self.table_name = 'kit_json_api_spec_chapters'

  self.allowed_columns = [
    :id,
    :created_at,
    :updated_at,
    :kit_json_api_spec_book_id,
    :title,
    :index,
  ]

  belongs_to(:book,
    class_name:  'Kit::JsonApiSpec::Models::Write::Book',
    foreign_key: 'kit_json_api_spec_book_id',
  )

end
