module Kit::JsonApiSpec::Resources::Author
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.available_fields
    {
      id:            Kit::JsonApi::TypesHint.defaults[Kit::JsonApi::TypesHint::IdNumeric],
      created_at:    Kit::JsonApi::TypesHint.defaults[Kit::JsonApi::TypesHint::Date],
      updated_at:    Kit::JsonApi::TypesHint.defaults[Kit::JsonApi::TypesHint::Date],
      name:          Kit::JsonApi::TypesHint.defaults[Kit::JsonApi::TypesHint::String],
      date_of_birth: Kit::JsonApi::TypesHint.defaults[Kit::JsonApi::TypesHint::Date],
      date_of_death: Kit::JsonApi::TypesHint.defaults[Kit::JsonApi::TypesHint::Date],
    }
  end

  def self.available_sort_fields
    available_fields
      .map { |name, _| [name, [:asc, :desc]] }
      .to_h
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
    # @note Here the filter is the same for the 3 relationships
    filter = ->(query_node:) do
      if (parent_data = query_node&.dig(:parent, :data) && parent_data.size > 0)
        Kit::JsonApi::Types::Condition[op: :in, column: :author_id, values: parent_data.map { |e| e[:id] }, upper_relationship: true]
      else
        nil
      end
    end

    {
      books: {
        #type:     [Kit::JsonApiSpec::Resources::Author, [:books, Kit::JsonApiSpec::Resources::Book]],
        resource:          Kit::JsonApiSpec::Resources::Book,
        type:              :many,
        inherited_filters: [filter],
      },
      series: {
        resource:          Kit::JsonApiSpec::Resources::Serie,
        type:              :many,
        inherited_filters: [filter],
      },
      photos: {
        resource:          Kit::JsonApiSpec::Resources::Photo,
        type:              :many,
        inherited_filters: [filter],
      },
    }
  end

  def self.resource
    @resource ||= Kit::JsonApi::Types::Resource[{
      name:                       :author,
      available_fields:           available_fields,
      available_sort_fields:      available_sort_fields,
      available_filters:          available_filters,
      upper_layer_relationship:   nil,
      available_relationships:    available_relationships,
      relationship_meta_defaults: {
        inclusion_top_level: true,
        inclusion_nested:    false,
      },
      data_loader:             self.method(:load_data),
    }]
  end

  before [
    #Ct::Hash[query_node: Ct::QueryNode],
    ->(query_node:) { query_node[:resource][:name] == :author },
  ]
  def self.load_data(query_node:)
    model = Kit::JsonApiSpec::Models::Write::Author
    sql   = Kit::JsonApi::Services::QueryResolver.generate_sql_query(
      table_name: model.table_name,
    )

    [:ok, data: model.find_by_sql(sql)]
  end

end