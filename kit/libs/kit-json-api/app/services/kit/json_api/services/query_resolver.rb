module Kit::JsonApi::Services::QueryResolver

  def self.resolve_query(json_api_query:)
    result      = resolve_node(query_node: json_api_query[:entry_node])
    status, ctx = result

    if status == :ok
      [:ok, json_api_query: json_api_query]
    else
      result
    end
  end

  def self.resolve_node(query_node:)
    Kit::Organizer.call({
      list: [
        self.method(:resolve_filters),
        self.method(:load_data),
        self.method(:resolve_relationships),
      ],
      ctx: { query_node: query_node, },
    })
  end

  def self.resolve_filters(query_node:)
    filters = query_node[:filters].map do |filter|
      if filter.respond_to?(:call)
        filter.call(query_node: query_node)
      else
        filter
      end
    end

    query_node[:filters] = filters

    [:ok, query_node: query_node]
  end

  def self.load_data(query_node:)
    result      = query_node[:data_loader].call(query_node: query_node)
    status, ctx = result

    if status == :ok
      query_node[:data] = ctx[:data]
      [:ok, query_node: query_node]
    else
      result
    end
  end

  def self.resolve_relationships(query_node:)
    query_node[:relationships].each do |_relationship_name, nested_query_node|
      status, ctx = result = resolve_node(query_node: nested_query_node)

      if status == [:error]
        return result
      end
    end

    [:ok, query_node: query_node]
  end

=begin
  # Load data for the `query_node`, add relationship filters to nested `query_nodes` & call itself to resolve them
  def self.resolve_node(query_node:)
    load_data(query_node: query_node)

    query_node[:relationships].each do |relationship_name, nested_query_node|
      add_relationship_data_to_nested_query_node(
        query_node:        query_node,
        relationship_name: relationship_name,
        nested_query_node: nested_query_node,
      )

      resolve_node(query_node: nested_query_node)
    end

    [:ok, query_node: query_node]
  end

  def self.load_data(query_node:)
    resource = query_node[:resource]
    callable = resource[:data_loader]
    data     = callable.call(
      query_node: query_node,
    )

    query_node[:data] = data

    [:ok, query_node: query_node]
  end

  def self.add_relationship_data_to_nested_query_node(query_node:, relationship_name:, nested_query_node:)
    resource = query_node[:resource]
    callable = resource[:relationships][relationship_name][:filter]

    # @note Only `data` should be needed by the receiver, but in case some funky implementation needs it, also send the `query_node`
    upper_relationship_data = relationship_filter.call(
      data:       query_node[:data],
      query_node: query_node,
    )

    nested_query_node[:upper_relationship] = {
      column_name: upper_relationship_data[:column_name],
      values:      upper_relationship_data[:values],
    }

    [:ok, nested_query_node: nested_query_node]
  end
=end


  # @note The SQL is generated for Postgres. Probably needs to be tuned for other DBs.
  def self.generate_sql_query(table_name:, filtering: [], sorting: [], limit: nil)
    sanitized_limit     = limit || 100
    sanitized_filtering = true
    sanitized_sorting   = true

    relationship_column = nil

    if relationship_column
      # @note We use a nested query to avoid naming collisions with the added attribute (rank)
      # @ref https://blog.jooq.org/2018/05/14/selecting-all-columns-except-one-in-postgresql/
      # @ref http://sqlfiddle.com/#!17/378a3/10

      sql = %{
        SELECT (data).*
          FROM (
            SELECT data,
                   RANK() OVER (PARTITION BY #{relationship_column} ORDER BY #{sanitized_sorting}) AS rank
              FROM #{table_name} data
              WHERE #{sanitized_filtering}
               /* AND {query_conditions}
                  AND ({relationship_column_name} IN ({relationship_values.join(', ')}))
               */
               ) AS ranked_data
         WHERE ranked_data.rank <= #{sanitized_limit}
      }
    else
    # @note Avoid the window function (RANK) when not needed
      sql = %{
          SELECT *
            FROM #{table_name}
           WHERE #{sanitized_filtering}
        ORDER BY #{sanitized_sorting}
           LIMIT #{sanitized_limit}
      }
    end

    sql
  end

end