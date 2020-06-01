# Handle Series.
module Kit::Store::Services::Table::Series

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Store::Contracts

  # NOTE: obviously non atomic / thread-safe
  contract Ct::Hash[table: Ct::Table, record: Ct::Record]
  def self.apply_to_record(table:, record:)
    table[:series].each do |column_name, properties|
      new_value               = properties[:get_new_value].call(last_value: properties[:last_value])
      properties[:last_value] = new_value
      record[column_name]     = new_value
    end

    [:ok, record: record]
  end

  contract Ct::Hash[table: Ct::Table, column_name: Ct::ColumnName, initial_value: Ct::Any, get_new_value: Ct::Callable]
  def self.add_to_table(table:, column_name:, initial_value:, get_new_value:)
    table[:series][column_name] = {
      last_value:    initial_value,
      get_new_value: get_new_value,
    }

    [:ok]
  end

  contract Ct::Hash[table: Ct::Table, column_name: Ct::ColumnName]
  def self.add_auto_increment(table:, column_name:)
    add_to_table(
      table:         table,
      column_name:   column_name,
      initial_value: 0,
      get_new_value: ->(last_value:) { last_value + 1 },
    )

    [:ok]
  end

end
