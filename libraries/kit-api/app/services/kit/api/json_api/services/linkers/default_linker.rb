# Serializer entry point.
#
# There are 2 categories
class Kit::Api::JsonApi::Services::Linkers::DefaultLinker

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  def self.to_h
    {
      single:                  self.method(:single),
      collection:              self.method(:collection),
      relationship_single:     self.method(:relationship_single),
      relationship_collection: self.method(:relationship_collection),
    }
  end

  # Presence:
  # - on every record
  # - possibly at the top level (virtually a to-one relationship)
  #
  # Impacted by:
  # - sparse fieldsets
  def self.single(record:)
    query_node      = record[:query_node]
    api_request     = query_node[:api_request]
    path            = query_node[:path]
    resource_object = record[:resource_object]

    links = links_single(resource_object: resource_object)[1][:links]

    generate_single_element_links(
      links:       links,
      api_request: api_request,
      path:        path,
      record:      record,
    )
  end

  def self.links_single(resource_object:, **)
    self_url_path = "/#{ resource_object[:type] }s/#{ resource_object[:id] }"
    links         = {
      self: self_url_path,
    }

    [:ok, links: links]
  end

  # Presence:
  # - at top level when requestion a collection (virtually a to-many relationship)
  #
  # Impacted by:
  # - sparse fieldsets
  # - sort
  # - filters
  # - related resources
  # - pagination
  def self.collection(query_node:, records:, paginator:)
    api_request    = query_node[:api_request]
    path           = query_node[:path]
    resource       = query_node[:resource]

    links = links_collection(resource: resource)[1][:links]

    generate_collection_links(
      links:       links,
      api_request: api_request,
      query_node:  query_node,
      path:        path,
      paginator:   paginator,
      records:     records,
    )
  end

  def self.links_collection(resource:, **)
    link_self_url_path = "/#{ resource[:name] }s"
    links              = {
      self: link_self_url_path,
      prev: link_self_url_path.dup,
      next: link_self_url_path.dup,
    }

    [:ok, links: links]
  end

  # Presence:
  # - in a resource object to-one relationship
  #
  # Impacted by:
  # - sparse fieldsets
  # - sort
  # - filters
  # - related resources
  def self.relationship_single(relationship:, record:, parent_record:)
    query_node             = relationship[:child_query_node]
    api_request            = record[:query_node][:api_request]
    path                   = query_node[:path]
    resource_object        = record[:resource_object]
    parent_resource_object = parent_record[:resource_object]

    links = links_relationship_single(
      query_node:             query_node,
      relationship:           relationship,
      resource_object:        resource_object,
      parent_resource_object: parent_resource_object,
    )[1][:links]

    generate_single_element_links(
      links:       links,
      api_request: api_request,
      path:        path,
      record:      record,
    )
  end

  def self.links_relationship_single(relationship:, resource_object:, parent_resource_object:, **)
    links = {
      self:      "/#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/relationships/#{ relationship[:name] }",
      related:   "/#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/#{ relationship[:name] }",
      top_level: "/#{ resource_object[:type] }s/ #{ resource_object[:id] }",
    }

    [:ok, links: links]
  end

  # Presence:
  # - in a resource object to-many relationship
  #
  # Impacted by:
  # - sparse fieldsets
  # - sort
  # - filters
  # - related resources
  # - pagination
  def self.relationship_collection(relationship:, records:, parent_record:, paginator:)
    api_request            = relationship[:child_query_node][:api_request]
    query_node             = relationship[:child_query_node]
    path                   = query_node[:path]
    parent_resource_object = parent_record[:resource_object]

    links = links_relationship_collection(
      query_node:             query_node,
      relationship:           relationship,
      parent_resource_object: parent_resource_object,
    )[1][:links]

    generate_collection_links(
      links:       links,
      api_request: api_request,
      query_node:  query_node,
      path:        path,
      paginator:   paginator,
      records:     records,
    )
  end

  def self.links_relationship_collection(query_node:, relationship:, parent_resource_object:, **)
    link_self_url_path = "/#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/relationships/#{ relationship[:name] }"
    links              = {
      self:      link_self_url_path,
      prev:      link_self_url_path.dup,
      next:      link_self_url_path.dup,
      related:   "/#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/#{ relationship[:name] }",
      top_level: "/#{ query_node[:resource][:name] }s",
    }

    [:ok, links: links]
  end

  # Generate links from single element.
  def self.generate_single_element_links(links:, api_request:, path:, record:)
    query_params = Kit::Api::JsonApi::Services::Request.create_query_params(api_request: api_request, path: path)[1][:query_params]

    links = links
      .map do |link_type, link_url_path|
        link = Kit::Api::JsonApi::Services::Url.path_to_link(
          url_path:     link_url_path,
          query_params: query_params,
        )[1][:link]

        [link_type, link]
      end
      .to_h

    [:ok, links: links]
  end

  # Generate paginated links from links paths.
  def self.generate_collection_links(links:, api_request:, path:, query_node:, paginator:, records:)
    query_params           = Kit::Api::JsonApi::Services::Request.create_query_params(api_request: api_request, path: path)[1][:query_params]
    paginator_query_params = paginator[:export].call(query_node: query_node, records: records)

    links = links
      .map do |link_type, link_url_path|
        paginator_link_type = link_type.in?([:self, :related, :top_level]) ? :current : link_type
        link_query_params   = query_params.merge(paginator_query_params[paginator_link_type] || {})

        link = Kit::Api::JsonApi::Services::Url.path_to_link(
          url_path:     link_url_path,
          query_params: link_query_params,
        )[1][:link]

        [link_type, link]
      end
      .to_h

    [:ok, links: links]
  end

end
