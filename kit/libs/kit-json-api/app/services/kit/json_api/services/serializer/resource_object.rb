module Kit::JsonApi::Services::Serializer::ResourceObject
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[query_node: Ct::QueryNode, document: Ct::Document, data_element: Ct::Any]
  after  Ct::Result[document: Ct::Document]
  # Serializes a single `resource_object`. Handles relationship resource linkage.
  # @note `data_element` is opaque to us. It is whatever was returned by the "resource loader", and the "resource serializer" is supposed to know how to handle it.
  def self.serialize_resource_object(query_node:, document:, data_element:)
    status, ctx = Kit::Organizer.call({
      list: [
        query_node[:resource][:serializer],
        self.method(:add_to_document_cache),
        self.method(:ensure_uniqueness),

        self.method(:add_resource_object_relationships_data),
        self.method(:add_parent_resource_object_relationships_data),
      ],
      ctx: {
        query_node:   query_node,
        document:     document,
        data_element: data_element,
      },
    })

    [:ok, ctx.slice(:document, :resource_object)]
  end

  # Add the resource_object to document cache.
  # Extend the resource_object if it already exists (loaded through different relationships).
  def self.add_to_document_cache(document:, query_node:, resource_object:)
    type = query_node[:resource][:name]
    id   = resource_object[:id].to_s

    if (cached_document = document[:cache][type][id])
      resource_object = cached_document.deep_merge(resource_object)
    end
    document[:cache][type][id] = resource_object

    [:ok, document: document]
  end

  # Ensures the resource_object is only included in the response once, per specs.
  def self.ensure_uniqueness(document:, query_node:, resource_object:)
    type = query_node[:resource][:name]
    id   = resource_object[:id].to_s

    # Include the element in the response only once.
    if !document[:included][type][id]
      document[:included][type][id] = true

      is_top_level = !query_node[:parent_query_node]
      document[:response][(is_top_level ? :data : :included)] << resource_object
    end

    [:ok, document: document]
  end

  # Adds relationship linkage when the knowledge of the relationship is defined on the current `data_element` (the "foreign key" is known directly on the current `data_element`, "belongs to" scenario).
  # @note The relationship `resource_object` might not yet be in the response, but all that is needed is the `id` anyway.
  def self.add_resource_object_relationships_data(query_node:, document:, resource_object:, data_element:)
    query_node[:relationship_query_nodes].each do |relationship_name, relationship_query_node|
      relationship = query_node[:resource][:relationships][relationship_name]

      resource_object[:relationships] ||= {}
      container = resource_object[:relationships][relationship_name] ||= {}

      next if !relationship[:inclusion][:resolve_child]

      _, linkage_data = relationship[:inclusion][:resolve_child].call(data_element: data_element)

      if relationship[:type] == :one
        container[:data] = linkage_data
      else
        container[:data] ||= []
        container[:data] << linkage_data
      end
    end

    [:ok, resource_object: resource_object]
  end

  # Adds relationship linkage to the *parent* `resource_object` when the knowledge of a parent relationship is defined on the current `data_element` (the "foreign key" was not known on the parent, but on the child, the current `dala_element`).
  # The relationship was defined on the parent resource but the foreign_key is on the current resource_object
  # @warning This acts on the *parent* `resource_object`.
  def self.add_parent_resource_object_relationships_data(query_node:, document:, resource_object:, data_element:)
    parent_query_node        = query_node[:parent_query_node]
    parent_relationship_name = query_node[:parent_relationship_name]
    return [:ok] if !parent_query_node || !parent_relationship_name

    relationship = parent_query_node[:resource][:relationships][parent_relationship_name]
    return [:ok] if !relationship[:inclusion][:resolve_parent]

    linkage_data = {
      type: query_node[:resource][:name],
      id:   resource_object[:id],
    }

    _, parent_linkage_data = relationship[:inclusion][:resolve_parent].call(data_element: data_element)

    parent_resource_object = document[:cache][parent_linkage_data[:type].to_sym][parent_linkage_data[:id].to_s]

    parent_resource_object[:relationships] ||= {}
    container = parent_resource_object[:relationships][parent_relationship_name] ||= {}

    if relationship[:type] == :one
      container[:data] = linkage_data
    else
      container[:data] ||= []
      container[:data] << linkage_data
    end

    [:ok, document: document]
  end

end