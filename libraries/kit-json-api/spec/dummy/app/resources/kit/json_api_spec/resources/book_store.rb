module Kit::JsonApiSpec::Resources::BookStore

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  include Kit::JsonApi::Resources::Resource

  def self.resource_name
    :book_store
  end

  def self.resource_url(resource_id:)
    "/book_stores/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/book_stores/#{ resource_id }/relationships/#{ relationship_id }"
  end

  def self.available_fields
    {
      id:         Kit::JsonApi::TypesHint::IdNumeric,
      created_at: Kit::JsonApi::TypesHint::Date,
      updated_at: Kit::JsonApi::TypesHint::Date,
      in_stock:   Kit::JsonApi::TypesHint::Boolean,
    }
  end

  def self.available_sort_fields
    available_fields
      .map { |name, _| [name, { order: [[name, :asc]], default: (name == :id) }] }
      .to_h
  end

  def self.available_filters
    available_fields
      .map { |name, type| [name, Kit::JsonApi::TypesHint.defaults[type]] }
      .to_h
  end

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::BookStore::Relationships::Book,
      Kit::JsonApiSpec::Resources::BookStore::Relationships::Store,
    ]

    list
      .map { |el| [el.relationship[:name],  el.relationship] }
      .to_h
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :book_store },
  ]
  def self.load_data(query_node:)
    model  = Kit::JsonApiSpec::Models::Write::BookStore
    _, ctx = Kit::JsonApi::Services::Sql.sql_query(
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

end
