module Kit::JsonApiSpec::Resources::Photo
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  after Ct::Resource
  def self.resource
    @resource ||= Kit::JsonApi::Types::Resource[{
      name:          :photo,
      fields:        available_fields.keys,
      relationships: available_relationships,
      sort_fields:   available_sort_fields,
      filters:       available_filters,
      data_loader:   self.method(:load_data),
      serializer:    self.method(:serialize),
    }]
  end

  def self.available_fields
    {
      id:         Kit::JsonApi::TypesHint::IdNumeric,
      created_at: Kit::JsonApi::TypesHint::Date,
      updated_at: Kit::JsonApi::TypesHint::Date,
      title:      Kit::JsonApi::TypesHint::String,
      uri:        Kit::JsonApi::TypesHint::String,
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
        type:              :many,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .select { |el| el[:imageable_type] == 'Kit::JsonApiSpec::Models::Write::Author' }
            .map    { |el| el[:imageable_id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
          # `resolve_child` receives the top level resource the relationship (chapter)
          resolve_child:   ->(data_element:) { [resource[:name], data_element.imageable_id] },
        },
      },
      book: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Book.resource },
        type:              :many,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .select { |el| el[:imageable_type] == 'Kit::JsonApiSpec::Models::Write::Book' }
            .map    { |el| el[:imageable_id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
          # `resolve_child` receives the top level resource the relationship (chapter)
          resolve_child:   ->(data_element:) { [resource[:name], data_element.imageable_id] },
        },
      },
      serie: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Serie.resource },
        type:              :many,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .select { |el| el[:imageable_type] == 'Kit::JsonApiSpec::Models::Write::Serie' }
            .map    { |el| el[:imageable_id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
          # `resolve_child` receives the top level resource the relationship (chapter)
          resolve_child:   ->(data_element:) { [resource[:name], data_element.imageable_id] },
        },
      },
    }
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :photo },
  ]
  def self.load_data(query_node:)
    model       = Kit::JsonApiSpec::Models::Write::Photo
    status, ctx = Kit::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA PHOTO: #{data.size}"

    [:ok, data: data]
  end

  # `element` is whatever was added to data. This is opaque.
  def self.serialize(data_element:, query_node:)
    resource = query_node[:resource]

    output = {
      type:          resource[:name],
      id:            data_element.id.to_s,
      attributes:    data_element.slice(resource[:fields] - [:id]),
    }
  end

end
