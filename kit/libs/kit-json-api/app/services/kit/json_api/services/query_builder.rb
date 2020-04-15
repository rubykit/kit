# Transform a request into a fully actionable AST
module Kit::JsonApi::Services::QueryBuilder

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[request: Ct::Request]
  def self.build_query(request:, condition: nil)
    request[:related_resources] ||= {}

    _, ctx = build_query_node(
      resource:        request[:top_level_resource],
      singular:        request[:singular],
      inclusion_level: 0,
      condition:       request[:condition],
      request:         request,
      path:            '',
    )

    [:ok, query: { entry_query_node: ctx[:query_node] }]
  end

  before [
    Ct::Hash[
      resource:                 Ct::Resource,
      parent_query_node:        Ct::Optional[Ct::QueryNode],
      parent_relationship_name: Ct::Optional[Ct::Symbol],
    ],
  ]
  after [
    Ct::Result[
      query_node: Ct::QueryNode,
      #data_loader: Ct::Optional[Ct::Callable],
    ],
  ]
  # Creates the AST of the query. Each `level` is a query node, even when there are 1:N or N:N scenarios.
  # For instance "Author -> Books -> Chapters" will be resolved as 3 corresponding query nodes total, eventhough there are many books, with many chapters.
  # Each type of relationship generates a query node even if they target the same resource.
  # For instance "Author -> [Chapter | FirstChapter]" will generate 3 corresponding query nodes total, eventhough the two relationships "Chapter" and "FirstChapter" target the same Resource (Chapter)
  def self.build_query_node(resource:, singular:, inclusion_level:, path:, request:, condition: nil, data_loader: nil)
    sorting = resource[:sort_fields].select { |_k, v| v[:default] == true }.first[1][:order]

    if singular == true
      limit = 1
    elsif limit == nil
      limit = request.dig(:limit, path)
    end

    if !limit.is_a?(Integer) || limit < 1
      limit = Kit::JsonApi::Services::Config.default_page_size
    end

    if limit > Kit::JsonApi::Services::Config.max_page_size
      limit = Kit::JsonApi::Services::Config.max_page_size
    end

    query_node = Kit::JsonApi::Types::QueryNode[
      resource:      resource,
      singular:      singular,
      condition:     condition,
      sorting:       sorting,
      data:          nil,
      limit:         limit,
      relationships: {},
      data_loader:   data_loader || resource[:data_loader],
    ]

    build_nested_relationships(
      query_node:      query_node,
      inclusion_level: inclusion_level,
      request:         request,
      path:            path,
    )

    [:ok, query_node: query_node]
  end

  def self.build_nested_relationships(query_node:, inclusion_level:, path:, request:)
    resource = query_node[:resource]

    inclusion_level += 1

    resource[:relationships].each do |relationship_name, relationship|
      nested_resource = relationship[:child_resource].call()
      nested_path = "#{ path }#{ path.empty? ? '' : '.' }#{ relationship[:name] }"

      if !request[:related_resources][nested_path] && ((request[:related_resources].size > 0) || relationship[:inclusion_level] < inclusion_level)
        next
      end

      _, ctx = build_query_node(
        resource:        nested_resource,
        inclusion_level: inclusion_level,
        condition:       relationship[:inherited_filter],
        data_loader:     relationship[:data_loader],
        singular:        relationship[:type] == :to_one,
        path:            nested_path,
        request:         request,
      )

      child_query_node = ctx[:query_node]

      relationship = relationship.dup
      relationship[:parent_query_node] = query_node
      relationship[:child_query_node]  = child_query_node

      query_node[:relationships][relationship_name] = relationship
      child_query_node[:parent_relationship] = relationship
    end

    [:ok, query_node: query_node]
  end

end
