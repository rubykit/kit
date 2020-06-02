# Serializer entry point.
module Kit::Api::JsonApi::Services::Linkers::DefaultLinker

  include Kit::Contract::Mixin
  # @hide true
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
    request         = query_node[:request]
    path            = query_node[:path]
    resource_object = record[:resource_object]

    query_params     = Kit::Api::JsonApi::Services::Request.create_query_params(request: request, path: path)
    query_params_str = query_params.size > 0 ? "?#{ Rack::Utils.build_nested_query(query_params) }" : ''

    links = {
      self: "/#{ resource_object[:type] }s#{ resource_object[:id] }#{ query_params_str }",
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
    request      = query_node[:request]
    path         = query_node[:path]
    resource     = query_node[:resource]

    query_params           = Kit::Api::JsonApi::Services::Request.create_query_params(request: request, path: path)
    paginator_query_params = paginator[:export].call(query_node: query_node, records: records)

    links = {
      self: "/#{ resource[:name] }s",
    }
    links.merge!({
      prev: links[:self].dup,
      next: links[:self].dup,
    })

    [:self, :prev, :next].each do |link_type|
      paginator_link_type = link_type.in?([:self, :related, :top_level]) ? :current : link_type
      link_query_params   = query_params.merge(paginator_query_params[paginator_link_type] || {})
      query_params_str    = link_query_params.size > 0 ? "?#{ Rack::Utils.build_nested_query(link_query_params) }" : ''

      links[link_type]   += query_params_str
    end

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
    request                = record[:query_node][:request]
    path                   = query_node[:path]
    resource_object        = record[:resource_object]
    parent_resource_object = parent_record[:resource_object]

    query_params     = Kit::Api::JsonApi::Services::Request.create_query_params(request: request, path: path)
    query_params_str = query_params.size > 0 ? "?#{ Rack::Utils.build_nested_query(query_params) }" : ''

    links = {
      self:      "/#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/relationships/#{ relationship[:name] }#{ query_params_str }",
      related:   "/#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/#{ relationship[:name] }#{ query_params_str }",
      top_level: "/#{ resource_object[:type] }s/ #{ resource_object[:id] }#{ query_params_str }",
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
    request                = relationship[:child_query_node][:request]
    query_node             = relationship[:child_query_node]
    path                   = query_node[:path]
    parent_resource_object = parent_record[:resource_object]

    links = {
      self:      "/#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/relationships/#{ relationship[:name] }",
      related:   "/#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/#{ relationship[:name] }",
      top_level: "/#{ query_node[:resource][:name] }s",
    }
    links.merge!({
      prev: links[:self].dup,
      next: links[:self].dup,
    })

    query_params           = Kit::Api::JsonApi::Services::Request.create_query_params(request: request, path: path)
    paginator_query_params = paginator[:export].call(query_node: query_node, records: records)

    [:self, :related, :top_level, :prev, :next].each do |link_type|
      paginator_link_type = link_type.in?([:self, :related, :top_level]) ? :current : link_type
      link_query_params   = query_params.merge(paginator_query_params[paginator_link_type] || {})
      query_params_str    = link_query_params.size > 0 ? "?#{ Rack::Utils.build_nested_query(link_query_params) }" : ''

      links[link_type]   += query_params_str
    end

    [:ok, links: links]
  end

end
