module Kit::JsonApi::Services::QueryBuilder
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

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
      data_loader: Ct::Optional[Ct::Callable],
    ],
  ]
  def self.build_query(resource:, parent_query_node: nil, parent_relationship_name: nil, condition: nil, data_loader: nil)
    sorting    = resource[:sort_fields].select { |k, v| v[:default] == true }.first[1][:order]

    query_node = Kit::JsonApi::Types::QueryNode[
      resource:                 resource,
      parent_query_node:        parent_query_node,
      parent_relationship_name: parent_relationship_name,
      condition:                condition,
      sorting:                  sorting,
      data:                     nil,
      limit:                    10,
      relationship_query_nodes: {},
      data_loader:              data_loader || resource[:data_loader],
    ]

    resource[:relationships].each do |relationship_name, relationship_data|
      next if !relationship_data[:inclusion][!parent_query_node ? :top_level : :nested]

      _, ctx = build_query(
        resource:                 relationship_data[:resource_resolver].call(),
        parent_relationship_name: relationship_name,
        parent_query_node:        query_node,
        condition:                relationship_data[:inherited_filter],
        data_loader:              relationship_data[:data_loader],
      )

      query_node[:relationship_query_nodes][relationship_name] = ctx[:query_node]
    end

    [:ok, query_node: query_node]
  end

end