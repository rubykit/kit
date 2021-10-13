class Kit::JsonApiSpec::Services::Linker < Kit::Api::JsonApi::Services::Linkers::DefaultLinker # rubocop:disable Style/Documentation

  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  UrlService = Kit::Router::Adapters::Http::Mountpoints

  def self.links_single(resource_object:)
    self_url_path = UrlService.url(id: "specs|api|#{ resource_object[:type] }|show", params: { resource_id: resource_object[:id] })
    links         = {
      self: self_url_path,
    }

    [:ok, links: links]
  end

  def self.links_collection(resource:, **)
    link_self_url_path = UrlService.url(id: "specs|api|#{ resource[:name] }|index")
    links              = {
      self: link_self_url_path,
      prev: link_self_url_path.dup,
      next: link_self_url_path.dup,
    }

    [:ok, links: links]
  end

  def self.links_relationship_single(relationship:, resource_object:, parent_resource_object:, **)
    start_url = UrlService.url(id: "specs|api|#{ parent_resource_object[:type] }|show", params: { resource_id: parent_resource_object[:id] })
    links     = {
      self:      "#{ start_url }/relationships/#{ relationship[:name] }",
      related:   "#{ start_url }/#{ relationship[:name] }",
      top_level: UrlService.url(id: "specs|api|#{ resource_object[:type] }|show", params: { resource_id: resource_object[:id] }),
    }

    [:ok, links: links]
  end

  def self.links_relationship_collection(query_node:, relationship:, parent_resource_object:)
    start_url          = UrlService.url(id: "specs|api|#{ parent_resource_object[:type] }|show", params: { resource_id: parent_resource_object[:id] })
    link_self_url_path = "#{ start_url }/relationships/#{ relationship[:name] }"
    links              = {
      self:      link_self_url_path,
      prev:      link_self_url_path.dup,
      next:      link_self_url_path.dup,
      related:   "#{ parent_resource_object[:type] }s/#{ parent_resource_object[:id] }/#{ relationship[:name] }",
      top_level: UrlService.url(id: "specs|api|#{ query_node[:resource][:name] }|index"),
    }

    [:ok, links: links]
  end

end
