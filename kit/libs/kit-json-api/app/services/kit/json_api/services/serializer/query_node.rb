module Kit::JsonApi::Services::Serializer::QueryNode
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[query_node: Ct::QueryNode, document: Ct::Document]
  after  Ct::Result[document: Ct::Document]
  # Serialize "every data" element in a QueryNode.
  # @note Handling the relationships is delegated to `serialize_resource_object`.
  def self.serialize_query_node(query_node:, document:)
    status, ctx = Kit::Organizer.call({
      list: [
        self.method(:add_resource_type_to_document),
        self.method(:serialize_query_node_data_elements),
        self.method(:if_top_level_add_links),
        self.method(:if_top_level_and_singular_flatten),
        self.method(:serialize_relationships_query_nodes),
      ],
      ctx: {
        query_node: query_node,
        document:   document,
      },
    })

    [:ok, document: ctx[:document]]
  end

  def self.add_resource_type_to_document(document:, query_node:)
    type = query_node[:resource][:name]

    document[:cache][type]    ||= {}
    document[:included][type] ||= {}

    [:ok, document: document]
  end

  # Serializes every `data element` in a query_node. Handles relationship resource linkage.
  def self.serialize_query_node_data_elements(query_node:, document:)
    resource_collection = []

    query_node[:data].each do |data_element|
      _, ctx = Kit::JsonApi::Services::Serializer::ResourceObject.serialize_resource_object(
        query_node:   query_node,
        data_element: data_element,
        document:     document,
      )

      resource_collection << ctx[:resource_object]
    end

    [:ok, document: document, resource_collection: resource_collection]
  end

  before Ct::Hash[query_node: Ct::QueryNode, document: Ct::Document]
  after  Ct::Result[document: Ct::Document]
  # Calls `serialize_query_node` on every relationship (nested) query node.
  # @note This contains the recursion that traverses the whole query AST.
  def self.serialize_relationships_query_nodes(query_node:, document:)
    query_node[:relationship_query_nodes].each do |_relationship_name, nested_query_node|
      status, ctx = result = serialize_query_node(
        query_node: nested_query_node,
        document:   document,
      )
    end

    [:ok, document: document]
  end

  # When dealing with the top level node, adds the top level `data` `links`
  def self.if_top_level_add_links(query_node:, document:, resource_collection:)
    return [:ok] if query_node[:parent_query_node]

    if query_node[:singular]
      links = resource_collection[0].dig(:links)
    else
      _, links = query_node[:resource][:links][:resource_collection].call(
        resource_collection: resource_collection,
        sorting:             query_node[:sorting],
      )
    end
    document[:response][:links] = links

    [:ok, document: document]
  end

  # When dealing with the top level node and a singular `resource object` requesy, transforms `data` from an array of a single `resource objects` to the `resource object` directly.
  def self.if_top_level_and_singular_flatten(query_node:, document:)
    if !query_node[:parent_query_node] && query_node[:singular]
      document[:response][:data] = document[:response][:data][0]
    end

    [:ok, document: document]
  end

end