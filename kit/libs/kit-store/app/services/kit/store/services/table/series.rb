module Kit::Store::Services::Table::Series

  # NOTE: obviously non atomic / thread-safe
  def self.apply_to_data(table:, data_hash:)
    table[:series].each do |column_name, properties|
      new_value               = properties[:get_new_value].call(last_value: properties[:last_value])
      properties[:last_value] = new_value
      data_hash[column_name]  = new_value
    end

    [:ok, data_hash: data_hash]
  end

  def self.add_to_table
  end

end