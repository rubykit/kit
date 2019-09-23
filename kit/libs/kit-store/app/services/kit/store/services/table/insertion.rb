module Kit::Store::Services::Table
  module Insertion
    extend T::Sig

    def self.insert(store:, table:, data:)
      status, ctx = Kit::Organizer.call({
        list: [
          self.method(:ensure_columns_exist),
          self.method(:to_data_array),
          self.method(:hydrate_with_auto_increments),
          Kit::Store::Services::Table::Constraints.method(:run_constraints),
          self.method(:add_data),
        ],
        ctx: {
          store:      store,
          table_name: table_name,
          data:       data,
        },
      })

      [status, store: store]
    end

    def self.add_data(table:, data_array:)
      table[:data_list] << data_array

      [:ok]
    end

    def self.ensure_columns_exist(table:, data:)
      errors = []
      data.keys.each do |column_name|
        if !table[:columns_hash][column_name]
          errors << "Column `#{column_name}` does not exist"
        end
      end

      if errors.size == 0
        [:ok]
      else
        [:errors, errors]
      end
    end

    def self.to_data_array(table:, data:)
      data_array = []

      table[:columns_hash].each do |k, v|
        data_array << data[k]
      end

      [:ok, data_array: data_array]
    end

    def self.hydrate_with_auto_increments(table:, data_array:)
      table[:auto_increments].each do |column_name, properties|
        idx                 = table[:columns_hash][column_name][:idx]
        value = properties[:value] += 1
        data_array[idx]     = value
      end

      [:ok, data_array: data_array]
    end

  end
end