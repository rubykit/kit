# Helpers to handle aliases logic for CLI methods
module Kit::Router::Services::Cli::Aliases

  # Get all aliases registered with the router
  # TODO: add routing namespacing
  def self.list(mount_type:)
    Kit::Organizer.call(
      list: [
        self.method(:list_aliases_and_endpoints),
        self.method(:add_parentage_data),
        self.method(:add_mountpoints),
      ],
      ctx:  { mount_type: mount_type },
    )
  end

  # Get aliases && endpoints from the router store
  def self.list_aliases_and_endpoints(mount_type:)
    list = {}

    {
      alias:    Kit::Router::Services::Store.router_store[:aliases],
      endpoint: Kit::Router::Services::Store.router_store[:endpoints],
    }.each do |type, type_list|
      type_list.each do |id, data|
        list[id] = {
          id:                    id,
          type:                  type,
          target_id:             data[:target_id]&.to_sym,
          mountpoints:           [data[:cached_mountpoints][mount_type]].reject(&:blank?),
          mountpoints_inherited: [],
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
  def self.add_mountpoints(list:)
    apply_to_children = ->(mountpoints:, children: []) do
      children.each do |child|
        child[:mountpoints_inherited].push(*mountpoints)
        apply_to_children.call(children: child[:children] || [], mountpoints: mountpoints)
      end
    end

    # Recurse through children of a mounted node to update their "mounted_indirectly" counter (propagate down)
    list.each do |_id, data|
      mountpoints = data[:mountpoints]
      next if mountpoints.empty?

      apply_to_children.call(children: data[:children], mountpoints: mountpoints)
    end

    # Loop through parents of a mounted node to update their "mounted_indirectly" counter (propagate up)
    list.each do |_id, data|
      mountpoints = data[:mountpoints]
      next if mountpoints.empty? || !data[:parent]

      tmp_parent = data[:parent]
      loop do
        tmp_parent[:mountpoints_inherited].push(*mountpoints)
        break if !(tmp_parent = tmp_parent[:parent])
      end
    end

    [:ok, list: list]
  end

end
