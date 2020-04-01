module Kit::JsonApiSpec::Resources::Store
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  include Kit::JsonApi::Resources::Resource

  def self.resource_name
    :store
  end

  def self.resource_url(resource_id:)
    "#{}/stores/#{resource_id}"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "#{}/stores/#{resource_id}/relationships/#{relationship_id}"
  end

  def self.available_fields
    {
      id:         Kit::JsonApi::TypesHint::IdNumeric,
      created_at: Kit::JsonApi::TypesHint::Date,
      updated_at: Kit::JsonApi::TypesHint::Date,
      name:       Kit::JsonApi::TypesHint::String,
    }
  end

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Store::Relationships::BookStores,
    ]

    list
      .map { |el| rs = el.relationship; [rs[:name], rs] }
      .to_h
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :store },
  ]
  def self.load_data(query_node:)
    model       = Kit::JsonApiSpec::Models::Write::Store
    status, ctx = Kit::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA STORE: #{data.size}"

    [:ok, data: data]
  end

end
