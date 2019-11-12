module Kit::Store::Services::Table::Insertion

  def self.insert(store:, table:, data:)
    arguments   = { store: store, table: table, data_hash: data }

    status, ctx = Kit::Organizer.call({
      list: [
        self.method(:ensure_columns_exist),
        Kit::Store::Services::Table::Series.method(:apply_to_data),
        Kit::Store::Services::Table::Constraints.method(:apply_to_data),
        self.method(:to_data_array),
        self.method(:persist),
      ],
      ctx: arguments,
    })

    [status, store: store, errors: ctx[:errors]]
  end

  def self.persist(table:, data_array:)
    table[:data_list] << data_array

    [:ok]
  end

  def self.ensure_columns_exist(table:, data_hash:)
    errors = []
    data_hash.keys.each do |column_name|
      if !table[:columns_hash][column_name]
        errors << { detail: "Kit::Store | Insertion: column `#{column_name}` does not exist" }
      end
    end

    if errors.size == 0
      [:ok]
    else
      [:errors, errors]
    end
  end

  def self.to_data_array(table:, data_hash:)
    data_array = []

    table[:columns_hash].each do |k, v|
      data_array << data_hash[k]
    end

    [:ok, data_array: data_array]
  end

end