require 'tabulo'

# Helpers methods to display routes & aliases
module Kit::Router::Services::CliDisplay

  def self.get_mountpoints
    list = []
    Kit::Router::Services::Store.router_store[:endpoints].each do |_endpoint_uid, endpoint_data|
      routes = endpoint_data.dig(:mountpoints, [:http, :rails])
      next if !routes

      routes.each do |route|
        list << { path: route[1], verb: route[0], uid: endpoint_data[:uid] }
      end
    end
  end

  def self.display_mountpoints
    list = get_mountpoints

    display_table = Tabulo::Table.new(list) do |table|
      table.add_column('Verb') { |data| data[:verb] }
      table.add_column('Path') { |data| data[:path] }
      table.add_column('Uid')  { |data| data[:uid] }

      table.pack(max_table_width: :auto)
    end

    puts display_table
  end

  def self.get_aliases
    list = {}

    Kit::Router::Services::Store.router_store[:aliases].each do |id, data|
      list[id] = { id: id, target_id: data[:target_id].to_sym, type: :alias }
    end
    Kit::Router::Services::Store.router_store[:endpoints].each do |id, data|
      list[id] = { id: id, type: :endpoint }
    end

    list.each do |_id, data|
      parent = list[data[:target_id]]
      if parent
        (parent[:children] ||= []) << data
      end
    end

    list
  end

  def self.display_aliases
    list = get_aliases

    display_table = Tabulo::Table.new(list.values) do |table|
      table.add_column('Id')     { |data| data[:id] }
      table.add_column('Target') { |data| data[:target_id] }
      table.add_column('Type')   { |data| data[:type] }

      table.pack(max_table_width: :auto)
    end

    puts display_table
  end

  def self.generate_alias_graph_assets(output_dir:)
    list = get_aliases

    values = list.select { |_id, data| data[:target_id] == nil }.values
    tree   = list_to_tree(list: values)

    generate_data_asset_file(tree: tree, output_dir: output_dir)
    copy_static_assets(output_dir: output_dir)

    [:ok]
  end

  def self.list_to_tree(list:)
    list.map do |el|
      res = {
        'name'     => el[:id],
        'endpoint' => el[:type] == :endpoint,
      }

      if el[:children]
        res['children'] = list_to_tree(list: el[:children])
      end

      res
    end
  end

  SRC_PATH = File.expand_path('../../../../../assets/src', __dir__)

  def self.copy_static_assets(output_dir:)
    FileUtils.mkdir_p(output_dir)

    ['aliases.html', 'aliases_chart.js', 'aliases_style.css'].each do |file_name|
      src = "#{ SRC_PATH }/#{ file_name }"
      FileUtils.cp(src, "#{ output_dir }/")
    end
  end

  def self.generate_data_asset_file(tree:, output_dir:)
    payload = {
      'name'     => '',
      'hidden'   => true,
      'children' => tree,
    }

    file_content = "var treeData = #{ JSON.pretty_generate(payload) };"

    dst = "#{ output_dir }/aliases_data.js"
    FileUtils.mkdir_p(File.dirname(dst))

    File.open(dst, 'w') { |file| file.write(file_content) }
  end

end
