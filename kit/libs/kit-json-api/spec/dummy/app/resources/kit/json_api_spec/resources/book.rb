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
    {
      author: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Author.resource },
        type:              :one,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .map { |e| e[:kit_json_api_spec_author_id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
        },
      },
      serie: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Serie.resource },
        type:              :one,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .map { |e| e[:kit_json_api_spec_serie_id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
        },
      },

      first_chapter: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Chapter.resource },
        type:              :one,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .map { |e| e[:id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :and, values: [
              Kit::JsonApi::Types::Condition[op: :in, column: :kit_json_api_spec_book_id, values: values, upper_relationship: true],
              Kit::JsonApi::Types::Condition[op: :eq, column: :ordering, values: 1],
            ],]
          else
            nil
          end
        end,
        inclusion: {
          top_level:      true,
          nested:         false,
        },
      },

      chapters: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Chapter.resource },
        type:              :many,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .map { |e| e[:id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :kit_json_api_spec_book_id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       false,
          nested:          false,
        },
      },

      book_stores: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::BookStore.resource },
        type:              :many,
        inherited_filter: ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .map { |e| e[:id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :kit_json_api_spec_book_id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       false,
          nested:          false,
        },
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
