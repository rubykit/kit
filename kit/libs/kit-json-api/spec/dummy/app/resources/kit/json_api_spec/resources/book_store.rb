module Kit::JsonApiSpec::Resources::BookStore
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  include Kit::JsonApi::Resources::Resource

  def self.resource_name
    :book_store
  end

  def self.resource_url(resource_id:)
    "#{}/book_stores/#{resource_id}"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "#{}/book_stores/#{resource_id}/relationships/#{relationship_id}"
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
      .map { |name, _| [name, { order: [[name, :asc]], default: (name == :id), }] }
      .to_h
  end

  def self.available_filters
    available_fields
      .map { |name, type| [name, Kit::JsonApi::TypesHint.defaults[type]] }
      .to_h
  end

  def self.available_relationships
    {
      books: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Book.resource },
        type:              :many,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent_query_node, :data) || [])
            .map { |el| el[:kit_json_api_spec_book_id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
          # `resolve_child` receives the top level resource the relationship (book_store)
          resolve_child:   ->(data_element:) { [:ok, type: resource[:name], id: data_element.kit_json_api_spec_book_id] },
        },
      },
      stores: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Store.resource },
        type:              :many,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent_query_node, :data) || [])
            .map { |el| el[:kit_json_api_spec_store_id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
          # `resolve_child` receives the top level resource the relationship (book_store)
          resolve_child:   ->(data_element:) { [:ok, type: resource[:name], id: data_element.kit_json_api_spec_store_id] },
        },
      },
    }
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :book_store },
  ]
  def self.load_data(query_node:)
    model       = Kit::JsonApiSpec::Models::Write::BookStore
    status, ctx = Kit::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA BOOK_STORE: #{data.size}"

    [:ok, data: data]
  end

end
