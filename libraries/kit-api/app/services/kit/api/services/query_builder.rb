# Build a `Query` (a fully actionable AST) from a `Request`.
#
# Each `level` is a query node, even when there are 1:N or N:N scenarios.
# For instance `Author -> Books -> Chapters` will be resolved as 3 corresponding query nodes total, eventhough there are many books, with many chapters.
#
# Each type of relationship generates a query node even if they target the same resource.
# For instance `Author -> [Chapter | FirstChapter]` will generate 3 corresponding query nodes total, eventhough the two relationships `Chapter` and `FirstChapter` target the same Resource (Chapter)
module Kit::Api::Services::QueryBuilder

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::Contracts

  before Ct::Hash[api_request: Ct::Request]
  after  Ct::Result[query_node: Ct::QueryNode]
  # Given a `Request`, creates the complete AST of the query.
  def self.build_query(api_request:, condition: nil)
    api_request[:related_resources] ||= {}

    _, ctx = build_query_node(
      api_request: api_request,
      resource:    api_request[:top_level_resource],
      singular:    api_request[:singular],
      condition:   api_request[:condition],
      path:        '',
    )

    [:ok, query_node: ctx[:query_node]]
  end

  before Ct::Hash[resource: Ct::Resource]
  after  Ct::Result[query_node: Ct::QueryNode]
  # Creates a `QueryNode` for a given layer.
  def self.build_query_node(api_request:, resource:, singular:, path:, condition: nil, resolvers: nil)
    # Filters
    if (filters_condition = resource.dig(:filters, path))
      condition = add_condition(initial_condition: condition, new_condition: filters_condition)
    end

    # Ordering
    ordering = nil
    if (path_ordering = resource.dig(:sorting, path))
      # TODO: reverse if negative order
      ordering = resource.dig(:sort_fields, path_ordering[:sort_name], :order)
    end
    # If none, select Resource default.
    if !ordering
      ordering = resource[:sort_fields].select { |_k, v| v[:default] == true }.first[1][:order]
    end

    # Limit
    _, ctx  = get_limit(api_request: api_request, path: path, singular: singular)
    limit   = ctx[:limit]

    # Pagination
    if (pagination_condition = resource.dig(:paginator, :condition))
      condition = add_condition(initial_condition: condition, new_condition: pagination_condition)
    end

    # Create QueryNode
    query_node = {
      path:          path.dup,
      resource:      resource,
      singular:      singular,
      condition:     condition,
      sorting:       ordering,
      limit:         limit,
      relationships: {},

      resolvers:     resolvers || { data_resolver: resource[:data_resolver] },

      #data_resolver: data_resolver || resource[:data_resolver],
      data:          nil,
      api_request:   api_request,
    }

    # Add relationships
    build_nested_relationships(
      api_request: api_request,
      query_node:  query_node,
      path:        path,
    )

    [:ok, query_node: query_node]
  end

  # Resolves the relationships of each `QueryNode`.
  #
  # This calls back `build_query_node`, creating the AST recursively.
  def self.build_nested_relationships(api_request:, query_node:, path:)
    resource = query_node[:resource]

    resource[:relationships].each do |relationship_name, relationship|
      nested_resource = api_request[:config][:resources][relationship[:resource]]
      nested_path     = "#{ path }#{ path.empty? ? '' : '.' }#{ relationship_name }"
      inclusion_level = (nested_path == '' ? 1 : 2) + nested_path.count('.')

      # Other related_resources were specified, but not this one
      next if !api_request[:related_resources][nested_path] && api_request[:related_resources].size > 0
      # If there is a relationship specific inclusion_level, use it, otherwise default to config.
      next if (relationship[:inclusion_level] || api_request[:config][:inclusion_level]) < inclusion_level

      resolvers = relationship[:resolvers]
      # Add resolver store
      if resolvers.is_a?(Array)
        _, ctx = Kit::Api::Services::Resolvers::ActiveRecord.generate_resolvers({
          config:       api_request[:config],
          relationship: relationship,
          options:      resolvers[1],
        })
        resolvers = ctx[:resolvers]
      end

      _, ctx = build_query_node(
        resource:    nested_resource,
        condition:   resolvers[:inherited_filter],
        resolvers:   resolvers,
        singular:    relationship[:relationship_type] == :to_one,
        path:        nested_path,
        api_request: api_request,
      )

      child_query_node = ctx[:query_node]

      relationship = relationship.dup
      relationship[:name]              = relationship_name
      relationship[:parent_query_node] = query_node
      relationship[:child_query_node]  = child_query_node
      relationship[:resolvers]         = resolvers

      query_node[:relationships][relationship_name] = relationship
      child_query_node[:parent_relationship] = relationship
    end

    [:ok, query_node: query_node]
  end

  # Get the limit value (size of the subset)
  def self.get_limit(api_request:, path:, singular:)
    limit = nil

    if singular == true
      limit = 1
    elsif limit == nil
      # Note: this is kind of cheating, not sure where it belongs.
      limit = api_request.dig(:pagination, path, :size)
    end

    if !limit.is_a?(Integer) || limit < 1
      limit = api_request[:config][:page_size]
    end

    if limit > api_request[:config][:page_size_max]
      limit = api_request[:config][:page_size_max]
    end

    [:ok, limit: limit]
  end

  def self.add_condition(initial_condition:, new_condition:)
    if initial_condition
      if initial_condition.is_a?(Hash) && initial_condition[:op] == :and
        initial_condition[:values] << pagination_condition
        initial_condition
      else
        { op: :and, values: [initial_condition, new_condition] }
      end
    else
      new_condition
    end
  end

end
