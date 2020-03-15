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
        self.method(:add_resource_object_to_cache),
        self.method(:ensure_uniqueness),
        self.method(:add_resource_object_relationships_data),
        self.method(:add_parent_resource_object_relationships_data),
        self.method(:add_relationship_links),
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
  def self.add_resource_object_to_cache(document:, query_node:, resource_object:, data_element:)
    document[:cache][:data_elements][data_element] = resource_object

    type     = query_node[:resource][:name]
    id       = resource_object[:id].to_s
    ro_cache = document[:cache][:resource_objects][type][id] ||= { data_elements: [], resource_object: nil, relationships: {} }

    if (cached_resourced_object = ro_cache[:resource_object])
      resource_object = cached_resourced_object.deep_merge(resource_object)
    end
    ro_cache[:resource_object] = resource_object

    if !ro_cache[:data_elements].include?(data_element)
      ro_cache[:data_elements] << data_element
    end

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

  def self.add_relationship_links(document:, query_node:, data_element:)
    query_node[:relationship_query_nodes].each do |relationship_name, nested_query_node|

    end

    [:ok, document: document]
  end

  # Adds relationship linkage when the knowledge of the relationship is defined on the current `data_element` (the "foreign key" is known directly on the current `data_element`, "belongs to" scenario).
  # @note The relationship `resource_object` might not yet be in the response, but all that is needed is the `id` anyway.
  def self.add_resource_object_relationships_data(query_node:, document:, resource_object:, data_element:)
    query_node[:relationship_query_nodes].each do |relationship_name, relationship_query_node|
      relationship = query_node[:resource][:relationships][relationship_name]

      next if !relationship[:inclusion][:resolve_child]

      _, linkage_data = relationship[:inclusion][:resolve_child].call(data_element: data_element)

      add_relationship_linkage(
        #relationship:    relationship,
        query_node:        query_node,
        relationship_name: relationship_name,
        document:          document,
        resource_object:   resource_object,
        linkage_data:      linkage_data,
      )
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
    parent_resource_object = document[:cache][:resource_objects][parent_linkage_data[:type].to_sym][parent_linkage_data[:id].to_s][:resource_object]

    add_relationship_linkage(
      #relationship:    relationship,
      query_node:        parent_query_node,
      relationship_name: parent_relationship_name,
      document:          document,
      resource_object:   parent_resource_object,
      linkage_data:      linkage_data,
    )

    [:ok, document: document]
  end

  def self.add_relationship_linkage(query_node:, relationship_name:, document:, resource_object:, linkage_data:)
    relationship = query_node[:resource][:relationships][relationship_name]

    resource_object[:relationships] ||= {}

    relationship_pathname = relationship_name
    # Get full relationship pathname to avoid collisions on collections.
    if relationship[:type] == :many
      tmp_qn                = query_node
      loop do
        break if !tmp_qn[:parent_query_node]
        relationship_pathname = "#{tmp_qn[:parent_relationship_name]}.#{relationship_pathname}"
        tmp_qn = tmp_qn[:parent_query_node]
      end
    end

    ro_type           = resource_object[:type].to_sym
    ro_id             = resource_object[:id].to_s
    rs_type           = linkage_data[:type].to_sym
    rs_id             = linkage_data[:id].to_s

    #relationship_cache = document[:cache][:resource_objects][ro_type][ro_id][:relationships]
    #relationship_cache[relationship_name] ||= {}
    #relationship_cache[relationship_name][rs_type] ||= {}

    # Protects against duplicates in a relationship list if a resource object has been loaded through different paths.
    # TODO: ASSESS! This might be impossible / entirely unecessary. Can THE SAME relationship have a different number of elements loaded through different paths?
    #if !relationship_cache[relationship_name][rs_type][rs_id]
      container = resource_object[:relationships][relationship_pathname] ||= {}

      if relationship[:type] == :one
        container[:data] = linkage_data
      else
        container[:data] ||= []
        container[:data] << linkage_data
      end

      #relationship_cache[relationship_name][rs_type][rs_id] = linkage_data
    #else
      # TODO: assess if we can have extended linkage data (more info than was previously available)
      #   If so, we need to merge.
    #end

    [:ok, document: document]
  end

  def self.add_relationship_links(query_node:, document:, data_element:)
    query_node[:relationship_query_nodes].each do |relationship_name, nested_query_node|
      # Can we trust the ordering?
      # Can there be conflicts if the resource object was loaded twice?

    end

    [:ok, document: document]
  end

end