class Kit::JsonApiSpec::Models::Read::Chapter < Kit::JsonApiSpec::Models::ReadRecord # rubocop:disable Style/Documentation

  self.table_name = 'kit_json_api_spec_chapters'

  self.whitelisted_columns = [
    :id,
    :created_at,
    :updated_at,
    :kit_json_api_spec_book_id,
    :title,
    :index,
  ]

  belongs_to :book, {
    class_name:  'Kit::JsonApiSpec::Models::Read::Book',
    foreign_key: 'kit_json_api_spec_book_id',
  }

end
