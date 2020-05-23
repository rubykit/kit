# Exemple type for dummy app.
class Kit::JsonApiSpec::Resources::Store < Kit::Api::JsonApi::Resources::ActiveRecordResource

  def self.name
    :store
  end

  def self.model
    Kit::JsonApiSpec::Models::Write::Store
  end

  def self.fields_setup
    {
      id:         { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at: { type: :date },
      updated_at: { type: :date },
      name:       { type: :string },
    }
  end

  def self.relationships
    {
      book_store: {
        resource:          :book_store,
        relationship_type: :to_many,
        resolvers:         [:active_record, child_field: :kit_json_api_spec_store_id],
      },
    }
  end

=begin

  def self.resource_url(resource_id:)
    "/stores/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/stores/#{ resource_id }/relationships/#{ relationship_id }"
  end

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Store::Relationships::BookStores,
    ]

    list
      .map { |el| [el.relationship[:name], el.relationship] }
      .to_h
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :store },
  ]
  def self.load_data(query_node:)
    model  = Kit::JsonApiSpec::Models::Write::Store
    _, ctx = Kit::Api::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA STORE: #{ data.size }"

    [:ok, data: data]
  end

=end

end
