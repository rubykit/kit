# Build a `Query` (a fully actionable AST) from a `Request`.
#
# Each `level` is a query node, even when there are 1:N or N:N scenarios.
# For instance `Author -> Books -> Chapters` will be resolved as 3 corresponding query nodes total, eventhough there are many books, with many chapters.
#
# Each type of relationship generates a query node even if they target the same resource.
# For instance `Author -> [Chapter | FirstChapter]` will generate 3 corresponding query nodes total, eventhough the two relationships `Chapter` and `FirstChapter` target the same Resource (Chapter)
module Kit::Api::JsonApi::Services::QueryBuilder

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  before Ct::Hash[request: Ct::Request]
  after  Ct::Result[entry_query_node: Ct::QueryNode]
  # Given a `Request`, creates the complete AST of the query.
  def self.build_query(request:, condition: nil)
    request[:related_resources] ||= {}

    _, ctx = build_query_node(
      request:   request,

      resource:  request[:top_level_resource],

      singular:  request[:singular],
      condition: request[:condition],
      path:      '',
    )

    [:ok, entry_query_node: ctx[:query_node]]
  end

  before Ct::Hash[resource: Ct::Resource]
  after  Ct::Result[query_node: Ct::QueryNode]
  # Creates a `QueryNode` for a given layer.
  def self.build_query_node(request:, resource:, singular:, path:, condition: nil, resolvers: nil)
    # Filters
    # add to conditions

    # Sorting
    sorting = resource[:sort_fields].select { |_k, v| v[:default] == true }.first[1][:order]

    # Limit
    _, ctx  = get_limit(request: request, path: path, singular: singular)
    limit   = ctx[:limit]

    # Create QueryNode
    query_node = {
      path:          path.dup,
      resource:      resource,
      singular:      singular,
      condition:     condition,
      sorting:       sorting,
      limit:         limit,
      relationships: {},

      resolvers:     resolvers || { data_resolver: resource[:data_resolver] },

      #data_resolver: data_resolver || resource[:data_resolver],
      data:          nil,
    }

    # Pagination
    if (paginator = request.dig(:config, :paginator))
      paginator.add_pagination_data_to_query_node(query_node: query_node)
    end

    # Add relationships
    build_nested_relationships(
      request:    request,
      query_node: query_node,
      path:       path,
    )

    [:ok, query_node: query_node]
  end

  # Resolves the relationships of each `QueryNode`.
  #
  # This calls back `build_query_node`, creating the AST recursively.
  def self.build_nested_relationships(request:, query_node:, path:)
    resource = query_node[:resource]

    resource[:relationships].each do |relationship_name, relationship|
      nested_resource = request[:config][:resources][relationship[:resource]]
      nested_path     = "#{ path }#{ path.empty? ? '' : '.' }#{ relationship_name }"
      inclusion_level = (nested_path == '' ? 1 : 2) + nested_path.count('.')

      # Other related_resources were specified, but not this one
      next if !request[:related_resources][nested_path] && request[:related_resources].size > 0
      # If there is a relationship specific inclusion_level, use it, otherwise default to config.
      next if (relationship[:inclusion_level] || request[:config][:inclusion_level]) < inclusion_level

      resolvers = relationship[:resolvers]
      # Add resolver store
      if resolvers.is_a?(Array)
        _, ctx = Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.generate_resolvers({
          config:       request[:config],
          relationship: relationship,
          options:      resolvers[1],
        })
        resolvers = ctx[:resolvers]
      end

      _, ctx = build_query_node(
        resource:  nested_resource,
        condition: resolvers[:inherited_filter],
        resolvers: resolvers,
        singular:  relationship[:relationship_type] == :to_one,
        path:      nested_path,
        request:   request,
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
  def self.get_limit(request:, path:, singular:)
    limit = nil

    if singular == true
      limit = 1
    elsif limit == nil
      limit = request.dig(:pagination, path, :size)
    end

    if !limit.is_a?(Integer) || limit < 1
      limit = request[:config][:page_size]
    end

    if limit > request[:config][:page_size_max]
      limit = request[:config][:page_size_max]
    end

    [:ok, limit: limit]
  end

end
