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
          mounted:            el[:mounted] > 0,
          mounted_indirectly: el[:mounted_indirectly] > 0,
          mounting_warning:   (el[:mounted] > 0 && el[:mounted_indirectly] > 0),
          children:           el[:children].size > 0,
        },
        children:       list_to_d3_tree(list: el[:children])[1][:tree],
      }
    end

    [:ok, tree: tree]
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
