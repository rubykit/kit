require 'tabulo'

# Helpers methods to display routes & aliases
module Kit::Router::Services::Cli

  # Display a table of available mountpoints
  # TODO: add routing namespace
  def self.display_mountpoints
    list = Kit::Router::Services::Cli::Mountpoints.list[1][:list]

    display_table = Tabulo::Table.new(list) do |table|
      table.add_column('Verb') { |data| data[:verb] }
      table.add_column('Path') { |data| data[:path] }
      table.add_column('Uid')  { |data| data[:uid] }

      table.pack(max_table_width: :auto)
    end

    puts display_table

    [:ok]
  end

  # Display a table of available aliases and their status
  # TODO: add routing namespace
  def self.display_aliases
    list = Kit::Router::Services::Cli::Aliases.aliases[1][:list]

    display_table = Tabulo::Table.new(list.values) do |table|
      table.add_column('Id')     { |data| data[:id] }
      table.add_column('Target') { |data| data[:target_id] }
      table.add_column('Type')   { |data| data[:type] }

      table.pack(max_table_width: :auto)
    end

    puts display_table

    [:ok]
  end

  # Generate a visual graph of aliases
  # TODO: add routing namespace
  def self.generate_alias_graph_assets(output_dir:)
    Kit::Organizer.call({
      list: [
        Kit::Router::Services::Cli::Aliases.method(:list),
        ->(list:) { [:ok, list: list.select { |_id, data| data[:target_id] == nil }.values] },
        Kit::Router::Services::Cli::AliasesGraph.method(:list_to_d3_tree),
        Kit::Router::Services::Cli::AliasesGraph.method(:generate_data_asset_file),
        Kit::Router::Services::Cli::AliasesGraph.method(:copy_static_assets),
      ],
      ctx:  {
        output_dir: output_dir,
      },
    })

    [:ok]
  end

end
