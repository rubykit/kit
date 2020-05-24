# Exemple type for dummy app.
class Kit::JsonApiSpec::Resources::Book < Kit::Api::JsonApi::Resources::ActiveRecordResource

  def self.name
    :book
  end

  def self.model
    Kit::JsonApiSpec::Models::Write::Book
  end

  def self.fields_setup
    {
      id:             { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at:     { type: :date },
      updated_at:     { type: :date },
      title:          { type: :string },
      date_published: { type: :date, sort_field: { order: :desc } },
    }
  end

  def self.relationships
    {
      author:        {
        resource:          :author,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: :kit_json_api_spec_author_id],
      },
      book_stores:   {
        resource:          :book_store,
        relationship_type: :to_many,
        resolvers:         [:active_record, child_field: :kit_json_api_spec_book_id],
      },
      chapters:      {
        resource:          :chapter,
        relationship_type: :to_many,
        resolvers:         [:active_record, child_field: :kit_json_api_spec_book_id],
      },
      first_chapter: {
        resource:          :chapter,
        relationship_type: :to_one,
        resolvers:         {
          inherited_filter: Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.generate_inherited_filters(relationship_type: :to_many, parent_field: { id: :id }, child_field: { id: :kit_json_api_spec_book_id }),
          records_selector: Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.generate_records_selector(relationship_type: :to_many, parent_field: { id: :id }, child_field: { id: :kit_json_api_spec_book_id }),
          data_resolver:    Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.generate_data_resolver({
            model: Kit::JsonApiSpec::Models::Write::Chapter,
          })[1][:data_resolver],
        },
      },
      photos:        {
        resource:          :photo,
        relationship_type: :to_many,
        resolvers:         [:active_record, foreign_key_field: [:imageable_id, :imageable_type, 'Kit::JsonApiSpec::Models::Write::Book']],
      },
      serie:         {
        resource:          :serie,
        relationship_type: :to_one,
        resolvers:         [:active_record, foreign_key_field: :kit_json_api_spec_serie_id],
      },
    }
  end

=begin

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Book::Relationships::Author,
      Kit::JsonApiSpec::Resources::Book::Relationships::BookStores,
      Kit::JsonApiSpec::Resources::Book::Relationships::Chapters,
      Kit::JsonApiSpec::Resources::Book::Relationships::FirstChapter,
      Kit::JsonApiSpec::Resources::Book::Relationships::Serie,
    ]

    list
      .map { |el| [el.relationship[:name], el.relationship] }
      .to_h
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == resource[:name] },
  ]
  def self.load_data(query_node:)
    model  = Kit::JsonApiSpec::Models::Write::Book
    _, ctx = Kit::Api::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA BOOK: #{ data.size }"

    [:ok, data: data]
  end

  def self.resource_url(resource_id:)
    "/books/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/books/#{ resource_id }/relationships/#{ relationship_id }"
  end
=end

end
