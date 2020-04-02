module Kit::JsonApi::Services::QueryBuilder
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.build_query(resource:, singular:, condition: nil)
    _, ctx = build_query_node(
      resource:        resource,
      singular:        singular,
      inclusion_level: 0,
      condition:       condition,
    )

    [:ok, query: { entry_query_node: ctx[:query_node] }]
  end

  before [
    Ct::Hash[{
      resource:                 Ct::Resource,
      parent_query_node:        Ct::Optional[Ct::QueryNode],
      parent_relationship_name: Ct::Optional[Ct::Symbol],
    }],
  ]
  after [
    Ct::Result[
      query_node:  Ct::QueryNode,
      #data_loader: Ct::Optional[Ct::Callable],
    ],
  ]
  # Creates the AST of the query. Each `level` is a query node, even when there are 1:N or N:N scenarios.
  # For instance "Author -> Books -> Chapters" will be resolved as 3 corresponding query nodes total, eventhough there are many books, with many chapters.
  # Each type of relationship generates a query node even if they target the same resource.
  # For instance "Author -> [Chapter | FirstChapter]" will generate 3 corresponding query nodes total, eventhough the two relationships "Chapter" and "FirstChapter" target the same Resource (Chapter)
  def self.build_query_node(resource:, singular:, inclusion_level:, condition: nil, data_loader: nil)
    sorting    = resource[:sort_fields].select { |k, v| v[:default] == true }.first[1][:order]

    if singular == true
      limit = 1
    elsif limit == nil
      limit = 10
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
    )

    [:ok, query_node: query_node]
  end

  def self.build_nested_relationships(query_node:, inclusion_level:)
    resource = query_node[:resource]

    inclusion_level += 1

    resource[:relationships].each do |relationship_name, relationship|
      next if relationship[:inclusion_level] < inclusion_level

      _, ctx = build_query_node(
        resource:        relationship[:child_resource].call(),
        inclusion_level: inclusion_level,
        condition:       relationship[:inherited_filter],
        data_loader:     relationship[:data_loader],
        singular:        relationship[:type] == :to_one,
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