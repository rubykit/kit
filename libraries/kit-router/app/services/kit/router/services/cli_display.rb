require 'tabulo'

module Kit::Router::Services::CliDisplay

  def self.show_mountpoints
    list = []
    Kit::Router::Services::Store.router_store[:endpoints].each do |_endpoint_uid, endpoint_data|
      routes = endpoint_data.dig(:mountpoints, [:http, :rails])
      next if !routes

      routes.each do |route|
        list << { path: route[1], verb: route[0], uid: endpoint_data[:uid] }
      end
    end

    display_table = Tabulo::Table.new(list) do |table|
      table.add_column('Verb') { |data| data[:verb] }
      table.add_column('Path') { |data| data[:path] }
      table.add_column('Uid')  { |data| data[:uid] }

      table.pack(max_table_width: :auto)
    end

    puts display_table

    #exit
  end

  def self.show_aliases
    list = []
    Kit::Router::Services::Store.router_store[:aliases].each do |alias_id, alias_data|
      list << { id: alias_id, target_id: alias_data[:target_id] }
    end

    display_table = Tabulo::Table.new(list) do |table|
      table.add_column('Id')     { |data| data[:id] }
      table.add_column('Target') { |data| data[:target_id] }

      table.pack(max_table_width: :auto)
    end

    puts display_table

    #exit
  end

  # "Tree" display.
  # - Find node that don't have children

end
