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
        self.method(:generate_records_resource_objects),
        self.method(:if_top_level_add_links),
        self.method(:if_top_level_and_singular_flatten),
        self.method(:serialize_relationships_query_nodes),
        self.method(:generate_records_relationships),
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

    document[:cache][:resource_objects][type] ||= {}
    document[:included][type] ||= {}

    [:ok, document: document]
  end

  # Serializes every `data element` in a query_node. Handles relationship resource linkage.
  def self.generate_records_resource_objects(query_node:, document:)
    collection = []

    query_node[:records].each do |record|
      _, ctx = Kit::JsonApi::Services::Serializer::ResourceObject.serialize_resource_object(
        document: document,
        record:   record,
      )
    end

    [:ok, document: document]
  end

  # Add the top level `data` `links` if this is the top level QueryNode
  def self.if_top_level_add_links(query_node:, document:)
=begin
    return [:ok] if query_node[:parent_query_node]

    if query_node[:singular]
      links = collection[0].dig(:links)
    else
      _, links = query_node[:resource][:links][:resource_collection].call(
        collection: collection,
        sorting:    query_node[:sorting],
      )
    end
    document[:response][:links] = links
=end

    [:ok, document: document]
  end

  # Flatten `data` from an array to a single `resource object` if this is the top level QueryNode and it is tagged as `singular`
  def self.if_top_level_and_singular_flatten(query_node:, document:)
    if !query_node[:parent_query_node] && query_node[:singular]
      document[:response][:data] = document[:response][:data][0]
    end

    [:ok, document: document]
  end

  before Ct::Hash[query_node: Ct::QueryNode, document: Ct::Document]
  after  Ct::Result[document: Ct::Document]
  # Calls `serialize_query_node` on every relationship (nested) query node.
  # @note This contains the recursion that traverses the whole query AST.
  def self.serialize_relationships_query_nodes(query_node:, document:)
    query_node[:relationships].each do |relationship_name, relationship|
      child_query_node = relationship[:child_query_node]

      status, ctx = result = serialize_query_node(
        query_node: child_query_node,
        document:   document,
      )
    end

    [:ok, document: document]
  end

  def self.generate_records_relationships(document:, query_node:)
    query_node[:records].each do |record|
      query_node[:relationships].each do |_relationship_name, relationship|
        _, ctx = Kit::JsonApi::Services::Serializer::Relationship.serialize_record_relationship(
          document:     document,
          relationship: relationship,
          record:       record,
        )
      end
    end

    [:ok, document: document]
  end

end