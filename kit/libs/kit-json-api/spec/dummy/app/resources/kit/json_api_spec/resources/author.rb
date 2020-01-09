module Kit::JsonApiSpec::Resources::Author
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
      name:          Kit::JsonApi::TypesHint::String,
      date_of_birth: Kit::JsonApi::TypesHint::Date,
      date_of_death: Kit::JsonApi::TypesHint::Date,
    }
  end

  def self.available_sort_fields
    {
      id:         { order: [[:id,         :asc]],              default: true },
      created_at: { order: [[:created_at, :asc], [:id, :asc]], },
      updated_at: { order: [[:updated_at, :asc], [:id, :asc]], },
      name:       { order: [[:name,       :asc], [:id, :asc]], },
    }
  end

  def self.available_filters
    fields_filters = available_fields
      .map { |name, type| [name, Kit::JsonApi::TypesHint.defaults[type]] }
      .to_h

    # @note Dummy filter, acts as an exemple
    filters = {
      alive: Kit::JsonApi::TypesHint.defaults[Kit::JsonApi::TypesHint::Boolean],
    }

    filters.merge(fields_filters)
  end

  def self.available_relationships
    belongs_to_filter = ->(query_node:) do
      if ((parent_data = query_node&.dig(:parent, :data)) && parent_data.size > 0)
        Kit::JsonApi::Types::Condition[op: :in, column: :kit_json_api_spec_author_id, values: parent_data.map { |e| e[:id] }, upper_relationship: true]
      else
        nil
      end
    end

    {
      books: {
        resource:         Kit::JsonApiSpec::Resources::Book.resource,
        type:             :many,
        inherited_filter: belongs_to_filter,
        inclusion: {
          top_level:      true,
          nested:         false,
        },
      },
=begin
      series: {
        resource:         Kit::JsonApiSpec::Resources::Serie.resource,
        type:             :many,
        inherited_filter: belongs_to_filter,
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
              Kit::JsonApi::Types::Condition[op: :eq, column: :imageable_type, values: ['Kit::JsonApiSpec::Models::Write::Author'], upper_relationship: true],
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
=end
    }
  end


  before [
    ->(query_node:) { query_node[:resource][:name] == :author },
  ]
  def self.load_data(query_node:)
    model       = Kit::JsonApiSpec::Models::Write::Author
    status, ctx = Kit::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA AUTHOR: #{data.size}"

    [:ok, data: data]
  end

end