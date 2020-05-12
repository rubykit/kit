module Kit::JsonApiSpec::Resources::Book

  include Kit::Contract
  Ct = Kit::Api::JsonApi::Contracts

  include Kit::Api::JsonApi::Resources::Resource

  def self.resource_name
    :book
  end

  def self.resource_url(resource_id:)
    "/books/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/books/#{ resource_id }/relationships/#{ relationship_id }"
  end

  def self.available_fields
    {
      id:             Kit::Api::JsonApi::TypesHint::IdNumeric,
      created_at:     Kit::Api::JsonApi::TypesHint::Date,
      updated_at:     Kit::Api::JsonApi::TypesHint::Date,
      title:          Kit::Api::JsonApi::TypesHint::String,
      date_published: Kit::Api::JsonApi::TypesHint::Date,
    }
  end

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Book::Relationships::Author,
      #Kit::JsonApiSpec::Resources::Book::Relationships::BookStores,
      #Kit::JsonApiSpec::Resources::Book::Relationships::Chapters,
      #Kit::JsonApiSpec::Resources::Book::Relationships::FirstChapter,
      #Kit::JsonApiSpec::Resources::Book::Relationships::Serie,
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

end
