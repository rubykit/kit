# Maintain Table structure.
module Kit::Store::Services::Table::Structure

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Store::Contracts

  contract Ct::Hash[store: Ct::Store, table_name: Ct::TableName]
  def self.create_table(store:, table_name:)
    status, = get_table(store: store, table_name: table_name)
    if status == [:ok]
      return [:error, "Kit::Store | Table `#{ table_name }` already exists"]
    end

    table = Kit::Store::Types::Table[{
      store:        store,
      name:         table_name,

      columns_hash: {},
      data_list:    [],

      series:       {},
      constraints:  {},
    }]

    add_column(table: table, column_name: :_id)
    Kit::Store::Services::Table::Series.add_auto_increment(table: table, column_name: :_id)

    store[:tables][table_name] ||= table

    [:ok, table: table]
  end

  contract Ct::Hash[table: Ct::Table, column_name: Ct::ColumnName]
  def self.add_column(table:, column_name:)
    if table[:columns_hash][column_name]
      return [:error, "Kit::Store | Table `#{ table[:name] }` column `#{ column_name }` column already exists"]
    end

    table[:columns_hash][column_name] = { name: column_name }
    table[:columns_hash][column_name][:data_array_idx] = table[:columns_hash].keys.index(column_name)

    [:ok, column: table[:columns_hash][column_name]]
  end

=begin
  # TODO: transform this to generic contracts addition
  def self.add_column_type_constraint(table:, column:, column_type:)
    column_name = column[:name]

    callable = ->(row_hash:, **) do
      value = row_hash[column_name]
      if (value.is_a?(column_type))
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
=end

  contract Ct::Hash[store: Ct::Store, table_name: Ct::TableName]
  def self.get_table(store:, table_name:)
    table = store[:tables][table_name]

    if table
      [:ok, table: table]
    else
      [:error, "Kit::Store | Table `#{ table_name }` does not exist"]
    end
  end

end
