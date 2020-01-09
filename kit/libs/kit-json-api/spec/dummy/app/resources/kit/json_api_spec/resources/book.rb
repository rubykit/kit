module Kit::JsonApiSpec::Resources::Book
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  after Ct::Resource
  def self.resource
    @resource ||= Kit::JsonApi::Types::Resource[{
      name:          :book,
      fields:        available_fields.keys,
      relationships: available_relationships,
      sort_fields:   available_sort_fields,
      filters:       available_filters,
      data_loader:   self.method(:load_data),
    }]
  end

  def self.available_fields
    {
      id:         Kit::JsonApi::TypesHint::IdNumeric,
      created_at: Kit::JsonApi::TypesHint::Date,
      updated_at: Kit::JsonApi::TypesHint::Date,
      title:      Kit::JsonApi::TypesHint::String,
      ordering:   Kit::JsonApi::TypesHint::Numeric,
    }
  end

  def self.available_sort_fields
    available_fields
      .map { |name, _| [name, { order: [[name, :asc]], default: (name == :id), }] }
      .to_h
  end

  def self.available_filters
    available_fields
      .map { |name, type| [name, Kit::JsonApi::TypesHint.defaults[type]] }
      .to_h
  end

  def self.available_relationships
    return {}

    {
      author: {
        resource: Kit::JsonApiSpec::Resources::Author,
        filter:  ->(data:, **) { [[:eq, :id, data[:author_id]]] },
        type:     :one,
      },
      chapters: {
        #type:     [Kit::JsonApiSpec::Resources::Author, [:books, Kit::JsonApiSpec::Resources::Book]],
        resource: Kit::JsonApiSpec::Resources::Chapter,
        filter:  ->(data:, **) { [[:eq, :book_id, data[:id]]] },
        type:     :many,
      },
      first_chapter: {
        resource: Kit::JsonApiSpec::Resources::Chapter,
        filter:  ->(data:, **) { [[:eq, :book_id, data[:id]], [:eq, :ordering, 1]] },
        type:     :one,
      },
      serie: {
        resource: Kit::JsonApiSpec::Resources::Serie,
        filter:  ->(data:, **) { [[:eq, :id, data[:serie_id]]] },
        type:     :one,
      },
      book_store: {
        resource: Kit::JsonApiSpec::Resources::BookStore,
        filter:  ->(data:, **) { [[:eq, :book_id, data[:id]]] },
        type:     :many,
      },
    }
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == resource[:name] }
  ]
  def self.load_data(query_node:)
    model       = Kit::JsonApiSpec::Models::Write::Book
    status, ctx = Kit::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA BOOK: #{data.size}"

    [:ok, data: data]
  end


end
