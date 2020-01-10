module Kit::JsonApi::Services::QueryResolver

  def self.resolve_query(query_node:)
    result      = resolve_node(query_node: query_node)
    status, ctx = result

    if status == :ok
      [:ok, query_node: query_node]
    else
      result
    end
  end

  def self.resolve_node(query_node:)
    Kit::Organizer.call({
      list: [
        self.method(:resolve_query_node_condition),
        self.method(:load_data),
        self.method(:resolve_relationships),
      ],
      ctx: { query_node: query_node, },
    })
  end

  def self.resolve_query_node_condition(query_node:)
    query_node[:condition] = resolve_condition(
      condition:  query_node[:condition],
      query_node: query_node,
    )

    [:ok, query_node: query_node]
  end

  def self.resolve_condition(condition:, query_node:)
    if condition.is_a?(Kit::JsonApi::Types::Condition)
      if condition[:op].in?([:or, :and])
        condition[:values] = condition[:values].map do |value|
          resolve_condition(condition: value, query_node: query_node)
        end
      end
    elsif condition.respond_to?(:call)
      condition = condition.call(query_node: query_node)
    end

    condition
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

end