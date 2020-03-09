module Kit::JsonApi::Services::QuerySerializer
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[query_node: Ct::QueryNode]
  after  Ct::Result[document: Ct::Document]
  def self.serialize_query(query_node:)
    Kit::Organizer.call({
      list: [
        self.method(:create_document),
        self.method(:serialize_query_node),
      ],
      ctx: { query_node: query_node, },
    })
  end

  after  Ct::Result[document: Ct::Document]
  def self.create_document
    document = Kit::JsonApi::Types::Document[{
      cache:    {},
      included: {},
      response: {
        data:     [],
        included: [],
      },
    }]

    [:ok, document: document]
  end

  before Ct::Hash[query_node: Ct::QueryNode, document: Ct::Document]
  after  Ct::Result[document: Ct::Document]
  # Serialize "every data" element in a QueryNode.
  # @note Handling the relationships is delegated to `serialize_resource_object`.
  def self.serialize_query_node(query_node:, document:)
    resource = query_node[:resource]
    type     = resource[:name]

    document[:cache][type]    ||= {}
    document[:included][type] ||= {}

    resource_collection = []

    query_node[:data].each do |raw_data_element|
      _, ctx = serialize_resource_object(
        query_node:       query_node,
        raw_data_element: raw_data_element,
        document:         document,
      )

      resource_collection << ctx[:resource_object]
    end

    if !query_node[:parent_query_node]
      if query_node[:singular]
        links = resource_collection[0].dig(:links)
      else
        _, links = resource[:links][:resource_collection].call(resource_collection: resource_collection, sorting: query_node[:sorting],)
      end
      document[:response][:links] = links
    #else
    #  generate_relationships_links(resource_collection: resource_collection, sorting: query_node[:sorting],)
    end

    # Resolve the relationships query_nodes recursively
    serialize_relationships_query_nodes(query_node: query_node, document: document)

    # Flatten top level `data` if it's a singular resource
    if !query_node[:parent_query_node] && query_node[:singular]
      document[:response][:data] = document[:response][:data][0]
    end

    [:ok, document: document]
  end

  before Ct::Hash[query_node: Ct::QueryNode, document: Ct::Document, raw_data_element: Ct::Any]
  after  Ct::Result[document: Ct::Document]
  def self.serialize_resource_object(query_node:, raw_data_element:, document:)
    resource        = query_node[:resource]
    type            = resource[:name]

    resource_object = resource[:serializer].call(query_node: query_node, data_element: raw_data_element)
    id              = resource_object[:id].to_s

    # Add the resource_object to document cache.
    # Extend the resource_object if it already exists (returned through different relationships)
    if (cached_document = document[:cache][type][id])
      resource_object = cached_document.deep_merge(resource_object)
    end
    document[:cache][type][id] = resource_object

    # Include the element in the response only once.
    if !document[:included][type][id]
      document[:included][type][id] = true
      is_top_level = !query_node[:parent_query_node]
      document[:response][(is_top_level ? :data : :included)] << resource_object
    end

    # Relationships are unidirectional. When the foreign_key is on the current data_element, there are 2 scenarios.
    # 1. The relationship is on the current resource
    add_resource_object_relationships_data(
      query_node:       query_node,
      document:         document,
      resource_object:  resource_object,
      raw_data_element: raw_data_element,
    )
    # 2. The relationship was actually on the parent resource and can only be resolved now
    add_parent_resource_object_relationships_data(
      query_node:       query_node,
      document:         document,
      resource_object:  resource_object,
      raw_data_element: raw_data_element,
    )

    [:ok, document: document, resource_object: resource_object]
  end

  # The relationship is defined on the current resource.
  # Add relationship data eventhough the relationship resource_object is probably not yet in the response.
  def self.add_resource_object_relationships_data(query_node:, document:, resource_object:, raw_data_element:)
    query_node[:relationship_query_nodes].each do |relationship_name, relationship_query_node|
      relationship = query_node[:resource][:relationships][relationship_name]
      next if !relationship[:inclusion][:resolve_child]

      resource_object[:relationships] ||= {}
      resource_object[:relationships][relationship_name] ||= {}
      container = resource_object[:relationships][relationship_name][:data] ||= []

      child_element_type, child_element_id = relationship[:inclusion][:resolve_child].call(data_element: raw_data_element)

      container << {
        type: child_element_type,
        id:   child_element_id,
      }
    end

    [:ok]
  end

  # The relationship was defined on the parent resource but the foreign_key is on the current resource_object
  def self.add_parent_resource_object_relationships_data(query_node:, document:, resource_object:, raw_data_element:)
    parent_query_node        = query_node[:parent_query_node]
    parent_relationship_name = query_node[:parent_relationship_name]
    return [:ok] if !parent_query_node || !parent_relationship_name

    relationship = parent_query_node[:resource][:relationships][parent_relationship_name]
    return [:ok] if !relationship[:inclusion][:resolve_parent]

    parent_element_type, parent_element_id = relationship[:inclusion][:resolve_parent].call(data_element: raw_data_element)

    parent_element = document[:cache][parent_element_type][parent_element_id.to_s]

    parent_element[:relationships] ||= {}
    parent_element[:relationships][parent_relationship_name] ||= {}
    container = parent_element[:relationships][parent_relationship_name][:data] ||= []

    container << {
      type: query_node[:resource][:name],
      id:   resource_object[:id],
    }

    [:ok]
  end

  before Ct::Hash[query_node: Ct::QueryNode, document: Ct::Document]
  after  Ct::Result[document: Ct::Document]
  def self.serialize_relationships_query_nodes(query_node:, document:)
    query_node[:relationship_query_nodes].each do |_relationship_name, nested_query_node|
      status, ctx = result = serialize_query_node(
        query_node: nested_query_node,
        document:   document,
      )
    end

    [:ok, document: document]
  end

end