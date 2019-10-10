module Kit::Store::Services::Table
  module Structure

    def self.create_table(store:, table_name:)
      status, _ = get_table(store: store, table_name: table_name)
      if status == [:ok]
        return [:error, "Kit::Store | Table `#{table_name}` already exists"]
      end

      table = {
        name:            table_name,
        columns_hash:    {},
        data_list:       [],

        #constraints:     {},
        #auto_increments: {},
      }

      add_column(table: table, column_name: :_id, column_type: Integer)
      add_auto_increment(table: table, column_name: :_id)

      store[:tables][table_name] ||= table

      [:ok, table: table]
    end

    def self.add_column(table:, column_name:)
      if table[:columns_hash][column_name]
        return [:error, "Kit::Store | Table `#{table[:name]}` column `#{column_name}` column already exists"]
      end

      table[:columns_hash][column_name] = { name: column_name }
      table[:columns_hash][column_name][:data_array_idx] = table[:columns_hash].keys.index(column_name)

      [:ok, column: table[:columns_hash][column_name]]
    end

    def self.add_column_type_constraint(table:, column:, column_type:)
      column_name = column[:name]

      callable = ->(row_hash:, **) do
        value = row_hash[column_name]
        if (value.is_a?(column_type)
          [:ok]
        else
          [:error, "Kit::Store | Invalid type for column `#{column_name}`: value `#{value}` is not a `#{column_type}`"]
        end
      end

      Kit::Store::Services::Table::Constraints.add_constraint(table: table, callable: callable)

      [:ok]
    end

    def self.add_column_type_foreign_key(table:, column_name:, foreign_table_name:, foreign_column_name:)
    end

    def self.get_table(store:, table_name:)
      table = store[:tables][table_name]

      if table
        [:ok, table: table]
      else
        [:error, "Kit::Store | Table `#{table_name}` does not exist"]
      end
    end

    def self.validate_foreign_reference
    end

    def self.add_auto_increment(table:, column_name:)
      table[:auto_increments][column_name] = {
        last_value:    0,
        get_new_value: ->(last_value:) { last_value + 1 },
      }

      [:ok]
    end

    def self.add_constraint()
      [:ok]
    end

    def self.add_foreign_key()

  end
end