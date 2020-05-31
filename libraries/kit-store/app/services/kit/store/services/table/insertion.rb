# Handles Insertion in Table.
module Kit::Store::Services::Table::Insertion

  include Kit::Contract
  # @hide true
  Ct = Kit::Store::Contracts

  # Attempt to insert `data` into `table`
  contract Ct::Hash[table: Ct::Table, data: Ct::Hash]
  def self.insert(table:, data:)
    store     = table[:store]
    arguments = { store: store, table: table, record_data: data }

    Kit::Organizer.call({
      list:   [
        self.method(:record_data_to_record),
        Kit::Store::Services::Table::Series.method(:apply_to_record),
        Kit::Store::Services::Table::Constraints.method(:apply_to_record),
        self.method(:to_inner_record),
        self.method(:persist),
      ],
      ctx:    arguments,
      filter: { ok: [:store], error: [:errors] },
    })
  end

  # Validate the `record_data` and convert it to a `record`
  contract Ct::Hash[table: Ct::Table, record_data: Ct::Hash]
  def self.record_data_to_record(table:, record_data:)
    errors = []
    record_data.each_key do |column_name|
      if !table[:columns_hash][column_name]
        errors << { detail: "Kit::Store | Insertion: column `#{ column_name }` does not exist" }
      end
    end

    if errors.size == 0
      [:ok, record: Kit::Store::Types::Record[record_data]]
    else
      [:errors, errors]
    end
  end

  # Convert a `Record` (hash access) to a `InnerRecord` (array)
  contract Ct::Hash[table: Ct::Table, record: Ct::Record]
  def self.to_inner_record(table:, record:)
    inner_record = Kit::Store::Types::InnerRecord.new

    table[:columns_hash].each do |k, _v|
      inner_record << record[k]
    end

    [:ok, inner_record: inner_record]
  end

  # Append the data to the `table`
  contract Ct::Hash[table: Ct::Table, inner_record: Ct::InnerRecord]
  def self.persist(table:, inner_record:)
    table[:data_list] << inner_record

    [:ok]
  end

end
