# Helpers for generating a visual graph of aliases
module Kit::Router::Services::Cli::AliasesGraph

  # Format the data for D3
  # TODO: update mounting data to take mount-type into account.
  def self.list_to_d3_tree(list: [])
    tree = list.map do |el|
      {
        name:           el[:id],
        kit_properties: {
          type:               el[:type],
          mounted:            el[:mountpoints].size > 0,
          mounted_indirectly: el[:mountpoints_inherited].size > 0,
          mounting_warning:   (el[:mountpoints].size > 0 && el[:mountpoints_inherited].size > 0),
          children:           el[:children].size > 0,
        },
        children:       list_to_d3_tree(list: el[:children])[1][:tree],
      }
    end

    [:ok, tree: tree]
  end

  # Quick hack to provide some namespacing for mountpoints.
  # TODO: do this properly this!
  def self.add_namespaces_to_tree(list:, tree:)
    new_tree    = []
    list_by_key = list.each_with_object({}) { |v, a| a[v[:id]] = v }

    # Reduce the namespaces && create nodes as we go
    find_or_create_node = ->(current_tree:, namespace:) do
      node = current_tree.find { |el| el[:name] == namespace[0] && el.dig(:kit_properties, :namespace) == true }

      if !node
        node = {
          name:           namespace[0],
          kit_properties: {
            namespace: true,
            children:  true,
          },
          children:       [],
        }

        current_tree << node
      end

      namespace.size == 1 ? node : find_or_create_node.call(current_tree: node[:children], namespace: namespace[1..])
    end

    # For each top-level node, nest it under namespace if available.
    tree.each do |node|
      data       = list_by_key[node[:name]]
      namespaces = data[:mountpoints].map { |el| el.dig(:meta, :namespace) }.reject(&:blank?) + data[:mountpoints_inherited].map { |el| el.dig(:meta, :namespace) }.reject(&:blank?)

      if namespaces.size == 0
        namespace = [:default]
      else
        namespace = namespaces.first
      end

      parent_node = find_or_create_node.call(current_tree: new_tree, namespace: namespace)
      parent_node[:children] << node
    end

    [:ok, tree: new_tree]
  end

  SRC_PATH = File.expand_path('../../../../../../assets/src', __dir__)

  # Copy static assets needed for the graph
  def self.copy_static_assets(output_dir:)
    FileUtils.mkdir_p(output_dir)

    ['aliases.html', 'aliases_chart.js', 'aliases_style.css'].each do |file_name|
      src = "#{ SRC_PATH }/#{ file_name }"
      FileUtils.cp(src, "#{ output_dir }/")
    end

    [:ok]
  end

  def self.generate_data_asset_file(tree:, output_dir:)
    payload = {
      name:           '',
      kit_properties: {
        hidden: true,
      },
      children:       tree,
    }

    file_content = "var treeData = #{ JSON.pretty_generate(payload) };"

    dst = "#{ output_dir }/aliases_data.js"
    FileUtils.mkdir_p(File.dirname(dst))

    File.open(dst, 'w') { |file| file.write(file_content) }

    [:ok]
  end

end
