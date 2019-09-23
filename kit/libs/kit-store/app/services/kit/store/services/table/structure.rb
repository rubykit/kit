module Kit::Store::Services::Table
  module Structure
    extend T::Sig

    def self.get_table(store:, table_name:)
      table = store[:tables][table_name]

      if table
        [:ok, table: table]
      else
        [:error, "Kit::Store | Table `#{table_name}` does not exist"]
      end
    end

    def self.create_table(store:, table_name:)
      status, _ = get_table(store: store, table_name: table_name)
      if status == [:ok]
        return [:error, "Kit::Store | Table `#{table_name}` already exists"]
      end

      table = {
        name:            table_name,
        columns_hash:    {},
        data_list:       [],
        constraints:     {},
        auto_increments: {},
      }

      add_column(table: table, column_name: :_id, column_type: Integer)
      add_auto_increment(table: table, column_name: :_id)

      store[:tables][table_name] ||= table

      [:ok, table: table]
    end

    def self.add_column(table:, column_name:, column_type:)
      if table[:columns_hash][column_name]
        return [:error, "Kit::Store | Table `#{table[:name]}` column `#{column_name}` column already exists"]
      end

      table[:columns_hash][column_name] = { name: column_name, type: column_type }
      table[:columns_hash][column_name][:idx] = table[:columns_hash].keys.index(column_name)

      [:ok]
    end

    def self.add_auto_increment(table:, column_name:)
      table[:auto_increments][column_name] = { value: 0 }

      [:ok]
    end

    def self.add_constraint()
      [:ok]
    end

  end
end