module Kit::JsonApi::Services::QueryBuilder
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[resource: Ct::Resource, parent: Ct::Optional[Ct::QueryNode]]
  after  Ct::Tupple[Ct::Eq[:ok], Ct::Hash[query_node: Ct::QueryNode]]
  def self.build_query(resource:, parent: nil, condition: nil)
    sorting    = resource[:sort_fields].select { |k, v| v[:default] == true }.first[1][:order]

    query_node = Kit::JsonApi::Types::QueryNode[
      resource:      resource,
      parent:        parent,
      condition:     condition,
      sorting:       sorting,
      data:          nil,
      limit:         10,
      relationships: {},
    ]

    resource[:relationships].each do |k, v|
      next if !v[:inclusion][!parent ? :top_level : :nested]

      _, ctx = build_query(
        resource:  v[:resource],
        parent:    query_node,
        condition: v[:inherited_filter],
      )

      query_node[:relationships][k] = ctx[:query_node]
    end

    [:ok, query_node: query_node]
  end

end