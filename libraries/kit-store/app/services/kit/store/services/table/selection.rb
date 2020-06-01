# Handles Selection from Table.
module Kit::Store::Services::Table::Selection

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Store::Contracts

  contract Ct::Hash[store: Ct::Store, from: Ct::TableName, select: Ct::Optional[Ct::ColumnNames], filters: Ct::Optional[Ct::Callables], order: Ct::Optional[Ct::Orders]]
  def self.select(store:, from:, select: nil, filters: nil, limit: nil, order: nil)
    filters ||= []

    if order
      filters << Kit::Store::Services::Table::Ordering.method(:order_by)
    end

    if limit.is_a?(Integer)
      limit_value = limit
      limit = ->(inner_records:) do
        [:ok, inner_records: inner_records[0...limit_value]]
      end
    end
    if limit.respond_to?(:call)
      filters << limit
    end

    list = [
      Kit::Store::Services::Table::Structure.method(:get_table),
      self.method(:select_all),
      filters,
      self.method(:deep_clone),
    ].flatten

    Kit::Organizer.call({
      list:   list,
      ctx:    {
        store:        store,
        table_name:   from,
        column_names: select,
        order:        order,
      },
      filter: { ok: [:records] },
    })
  end

  contract Ct::Hash[table: Ct::Table]
  def self.select_all(table:)
    [:ok, inner_records: table[:data_list]]
  end

  contract Ct::Hash[table: Ct::Table, inner_record: Ct::InnerRecord, column_name: Ct::ColumnName]
  def self.get(table:, inner_record:, column_name:)
    _, ctx = get_data_array_idx(table: table, column_name: column_name)

    [:ok, value: inner_record[ctx[:data_array_idx]]]
  end

  contract Ct::Hash[table: Ct::Table, column_name: Ct::ColumnName]
  def self.get_data_array_idx(table:, column_name:)
    [:ok, data_array_idx: table[:columns_hash][column_name][:data_array_idx]]
  end

  contract Ct::Hash[table: Ct::Table, inner_records: Ct::InnerRecords, column_names: Ct::Optional[Ct::ColumnNames]]
  def self.deep_clone(table:, inner_records:, column_names: nil)
    keys = table[:columns_hash].keys

    records = inner_records
      .map { |record| [keys, record.deep_dup].transpose.to_h }

    if column_names
      records = records
        .map { |record| record.slice(*column_names) }
    end

    [:ok, records: records]
  end

end
