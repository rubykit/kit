module Kit::JsonApiSpec::Resources::Serie
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  after Ct::Resource
  def self.resource
    @resource ||= Kit::JsonApi::Types::Resource[{
      name:          :author,
      fields:        available_fields.keys,
      relationships: available_relationships,
      sort_fields:   available_sort_fields,
      filters:       available_filters,
      data_loader:   self.method(:load_data),
    }]
  end

  def self.available_fields
    {
      id:            Kit::JsonApi::TypesHint::IdNumeric,
      created_at:    Kit::JsonApi::TypesHint::Date,
      updated_at:    Kit::JsonApi::TypesHint::Date,
      title:         Kit::JsonApi::TypesHint::String,
    }
  end

  def self.available_sort_fields
    available_fields
      .map { |name, _| [name, { order: [[name, :asc]], default: (name == :id), }] }
      .to_h
  end

  def self.available_filters
    fields_filters = available_fields
      .map { |name, type| [name, Kit::JsonApi::TypesHint.default_filters[type]] }
      .to_h
  end

  def self.available_relationships
    {
      books: {
        resource:         Kit::JsonApiSpec::Resources::Book.resource,
        type:             :many,
        inherited_filter: ->(query_node:) do
          if ((parent_data = query_node&.dig(:parent, :data)) && parent_data.size > 0)
            Kit::JsonApi::Types::Condition[op: :in, column: :kit_json_api_spec_serie_id, values: parent_data.map { |e| e[:id] }, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:      true,
          nested:         false,
        },
      },
      photos: {
        resource:         Kit::JsonApiSpec::Resources::Photo.resource,
        type:             :many,
        inherited_filter: ->(query_node:) do
          if ((parent_data = query_node&.dig(:parent, :data)) && parent_data.size > 0)
            Kit::JsonApi::Types::Condition[op: :and, values: [
              Kit::JsonApi::Types::Condition[op: :in, column: :imageable_id,   values: parent_data.map { |e| e[:id] }, upper_relationship: true],
              Kit::JsonApi::Types::Condition[op: :eq, column: :imageable_type, values: ['Kit::JsonApiSpec::Models::Write::Serie'], upper_relationship: true],
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
    }
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :serie },
  ]
  def self.load_data(query_node:)
    model       = Kit::JsonApiSpec::Models::Write::Serie
    status, ctx = Kit::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA SERIE: #{data.size}"

    [:ok, data: data]
  end

end
