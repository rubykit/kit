module Kit::JsonApiSpec::Resources::Serie
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  after Ct::Resource
  def self.resource
    @resource ||= Kit::JsonApi::Types::Resource[{
      name:          :serie,
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
      authors: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Author.resource },
        type:              :many,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .map { |el| el[:id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :'kit_json_api_spec_books.kit_json_api_spec_serie_id', values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
          # `resolve_parent` receives the resource inside the relationship (serie)
          resolve_parent: ->(data_element:) { [resource[:name], data_element.read_attribute(:kit_json_api_spec_serie_id)] },
        },
        data_loader:       self.method(:load_authors_relationship_data),
      },
      books: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Book.resource },
        type:              :many,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .map { |el| el[:id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :in, column: :kit_json_api_spec_serie_id, values: values, upper_relationship: true]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
          # `resolve_parent` receives the resource inside the relationship (book)
          resolve_parent:  ->(data_element:) { [resource[:name], data_element.kit_json_api_spec_serie_id] },
        },
      },
      photos: {
        resource_resolver: ->() { Kit::JsonApiSpec::Resources::Photo.resource },
        type:              :many,
        inherited_filter:  ->(query_node:) do
          values = (query_node&.dig(:parent, :data) || [])
            .map { |el| el[:id] }
          if values.size > 0
            Kit::JsonApi::Types::Condition[op: :and, values: [
              Kit::JsonApi::Types::Condition[op: :in, column: :imageable_id,   values: values, upper_relationship: true],
              Kit::JsonApi::Types::Condition[op: :eq, column: :imageable_type, values: ['Kit::JsonApiSpec::Models::Write::Serie']],
            ],]
          else
            nil
          end
        end,
        inclusion: {
          top_level:       true,
          nested:          false,
          # `resolve_parent` receives the resource inside the relationship (image)
          resolve_parent: ->(data_element:) { [resource[:name], data_element.imageable_id] },
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

  before [
    ->(query_node:) { query_node[:resource][:name] == :author },
  ]
  def self.load_authors_relationship_data(query_node:)
    ar_model    = Kit::JsonApiSpec::Models::Write::Author

    status, ctx = Kit::Organizer.call({
      list: [
        Kit::JsonApi::Services::Sql::Filtering.method(:filtering_to_sql_str),
        Kit::JsonApi::Services::Sql::Sorting.method(:sorting_to_sql_str),
        Kit::JsonApi::Services::Sql.method(:detect_relationship),
        self.method(:generate_authors_relationship_sql_query),
      ],
      ctx: {
        filtering:           query_node[:condition],
        sorting:             query_node[:sorting],
        ar_connection:       ar_model.connection,
        table_name:          ar_model.table_name,
        sanitized_limit_sql: query_node[:limit].to_i.to_s,
      },
    })

    puts ctx[:sql_str]
    data = ar_model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA RS AUTHORS: #{data.size}"

    [:ok, data: data]
  end

  def self.generate_authors_relationship_sql_query(table_name:, sanitized_filtering_sql:, sanitized_sorting_sql:, sanitized_limit_sql:, foreign_key_column_name: nil)
    joined_table = "kit_json_api_spec_books"
    sql = %{
      SELECT (#{table_name}).*, kit_json_api_spec_serie_id
        FROM (
          SELECT #{table_name},
                 #{foreign_key_column_name} AS kit_json_api_spec_serie_id,
                 RANK() OVER (PARTITION BY #{foreign_key_column_name} ORDER BY #{sanitized_sorting_sql}) AS rank
            FROM #{table_name}
            JOIN #{joined_table} ON #{joined_table}.kit_json_api_spec_serie_id = #{table_name}.id
           WHERE #{sanitized_filtering_sql}
        GROUP BY #{table_name}.id, #{foreign_key_column_name}
             ) AS ranked_data
       WHERE ranked_data.rank <= #{sanitized_limit_sql}
    }

    [:ok, sql_str: sql]
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
