# Exemple type for dummy app.
module Kit::JsonApiSpec::Resources::BookStore

  include Kit::Api::JsonApi::Resources::ActiveRecordResource

  def self.name
    :book_store
  end

  def self.model
    Kit::JsonApiSpec::Models::Write::BookStore
  end

  def self.fields_setup
    {
      id:         { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at: { type: :date },
      updated_at: { type: :date },
      in_stock:   { type: :boolean },
    }
  end

  def self.relationships
    {
      book:  {
        resource:          :book,
        relationship_type: :to_one,
        resolver:          [:active_record, foreign_key_field: :kit_json_api_spec_book_id],
      },
      store: {
        resource:          :store,
        relationship_type: :to_one,
        resolver:          [:active_record, foreign_key_field: :kit_json_api_spec_store_id],
      },
    }
  end

=begin

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::BookStore::Relationships::Book,
      Kit::JsonApiSpec::Resources::BookStore::Relationships::Store,
    ]

    list
      .map { |el| [el.relationship[:name],  el.relationship] }
      .to_h
  end

  def self.resource_url(resource_id:)
    "/book_stores/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/book_stores/#{ resource_id }/relationships/#{ relationship_id }"
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :book_store },
  ]
  def self.load_data(query_node:)
    model  = Kit::JsonApiSpec::Models::Write::BookStore
    _, ctx = Kit::Api::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA BOOK_STORE: #{ data.size }"

    [:ok, data: data]
  end
=end

end
