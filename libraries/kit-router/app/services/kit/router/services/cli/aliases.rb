# Helpers to handle aliases logic for CLI methods
module Kit::Router::Services::Cli::Aliases

  # Get all aliases registered with the router
  # TODO: add routing namespacing
  def self.list
    Kit::Organizer.call({
      list: [
        self.method(:list_aliases_and_endpoints),
        self.method(:add_parentage_data),
        self.method(:add_mounting_data),
      ],
    })
  end

  # Get aliases && endpoints from the router store
  def self.list_aliases_and_endpoints
    list = {}

    {
      alias:    Kit::Router::Services::Store.router_store[:aliases],
      endpoint: Kit::Router::Services::Store.router_store[:endpoints],
    }.each do |type, type_list|
      type_list.each do |id, data|
        list[id] = {
          id:                 id,
          type:               type,
          target_id:          data[:target_id]&.to_sym,
          mounted:            (data[:cached_mountpoints]&.size || 0),
          mounted_indirectly: 0,
        }
      end
    end

    [:ok, list: list]
  end

  # Add parent & children data to each node
  def self.add_parentage_data(list:)
    list.each do |_id, data|
      data[:children] ||= []

      parent = list[data[:target_id]]
      if parent
        data[:parent] = parent
        (parent[:children] ||= []) << data
      end
    end

    [:ok, list: list]
  end

  # Propagate the "mounted indirectly" status to parent & children node.
  def self.add_mounting_data(list:)
    apply_to_children = ->(children: []) do
      children.each do |child|
        child[:mounted_indirectly] += 1
        apply_to_children.call(children: child[:children] || [])
      end
    end

    # Recurse through children of a mounted node to update their "mounted_indirectly" counter (propagate down)
    list.each do |_id, data|
      next if data[:mounted] == 0

      apply_to_children.call(children: data[:children])
    end

    # Loop through parents of a mounted node to update their "mounted_indirectly" counter (propagate up)
    list.each do |_id, data|
      next if (data[:mounted] == 0) || !data[:parent]

      tmp_parent = data[:parent]
      loop do
        tmp_parent[:mounted_indirectly] += 1
        break if !(tmp_parent = tmp_parent[:parent])
      end
    end

    [:ok, list: list]
  end

end
