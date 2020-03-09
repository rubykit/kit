module Kit::JsonApiSpec::Resources::Chapter
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  include Kit::JsonApi::Resources::Resource

  def self.resource_name
    :chapter
  end

  def self.resource_url(resource_id:)
    "#{}/chapters/#{resource_id}"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "#{}/chapters/#{resource_id}/relationships/#{relationship_id}"
  end

  def self.available_fields
    {
      id:       Kit::JsonApi::TypesHint::IdNumeric,
      title:    Kit::JsonApi::TypesHint::String,
      ordering: Kit::JsonApi::TypesHint::Numeric,
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
      book: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Book.resource },
        type:              :one,
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
          # `resolve_child` receives the top level resource the relationship (chapter)
          resolve_child:   ->(data_element:) { [resource[:name], data_element.kit_json_api_spec_book_id] },
        },
      },
    }
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :chapter },
  ]
  def self.load_data(query_node:)
    model       = Kit::JsonApiSpec::Models::Write::Chapter
    status, ctx = Kit::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA CHAPTER: #{data.size}"

    [:ok, data: data]
  end

  def self.serialize(data_element:, query_node:)
    resource = query_node[:resource]

    output = {
      type:       resource[:name],
      id:         data_element.id.to_s,
      attributes: data_element.slice(resource[:fields] - [:id, :ordering]).merge(ordering: data_element.index),
    }
  end

end
