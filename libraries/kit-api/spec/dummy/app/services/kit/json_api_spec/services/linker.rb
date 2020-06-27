class Kit::JsonApiSpec::Services::Linker < Kit::Api::JsonApi::Services::Linkers::DefaultLinker # rubocop:disable Style/Documentation

  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  UrlService = Kit::Router::Services::Adapters::Http::Mountpoints

  # TODO: replace paths by router helpers
  def self.links_single(resource_object:)
    # Ex: Kit::Router.route('specs|api|authors|index', id: resource_object[:id])
    self_url_path = UrlService.path(id: "specs|api|#{ resource_object[:type] }|show", params: { resource_id: resource_object[:id] })
    links         = {
      self: self_url_path,
    }

    [:ok, links: links]
  end

  # TODO: replace paths by router helpers
  def self.links_collection(resource:, **)
    link_self_url_path = UrlService.path(id: "specs|api|#{ resource[:name] }|index")
    links              = {
      self: link_self_url_path,
      prev: link_self_url_path.dup,
      next: link_self_url_path.dup,
    }

    [:ok, links: links]
  end

  # TODO: replace paths by router helpers
  def self.links_relationship_single(relationship:, resource_object:, parent_resource_object:, **)
    links = {
      self:      "#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/relationships/#{ relationship[:name] }",
      related:   "#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/#{ relationship[:name] }",
      top_level: UrlService.path(id: "specs|api|#{ resource_object[:type] }|show", params: { resource_id: resource_object[:id] }),
    }

    [:ok, links: links]
  end

  def self.links_relationship_collection(query_node:, relationship:, parent_resource_object:)
    link_self_url_path = "#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/relationships/#{ relationship[:name] }"
    links              = {
      self:      link_self_url_path,
      prev:      link_self_url_path.dup,
      next:      link_self_url_path.dup,
      related:   "#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/#{ relationship[:name] }",
      top_level: UrlService.path(id: "specs|api|#{ query_node[:resource][:name] }|index"),
    }

    [:ok, links: links]
  end

end
