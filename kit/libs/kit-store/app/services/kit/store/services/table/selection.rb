module Kit::Store::Services::Table::Selection

  def self.select(store:, from:, select: nil, where: [], limit: nil, order: nil)
    if !where.is_a?(Array)
      where = [where]
    end

    filters = []
    where.each do |filter|
      if filter.respond_to?(:call)
        filters << filter
      end
    end

    if order
      filters << Kit::Store::Services::Table::Ordering.method(:order_by)
    end

    if limit.is_a?(Integer)
      limit_value = limit
      limit = ->(inner_records:) do
        [:ok, inner_records: inner_records[0...(limit_value)]]
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
      list: list,
      ctx: {
        store:       store,
        table_name:  from,
        columns:     select,
        order:       order,
      },
      filter: { ok: [:records], },
    })
  end

  def self.select_all(table:)
    [:ok, inner_records: table[:data_list]]
  end

  def self.get(table:, inner_record:, column:)
    _, ctx = get_data_array_idx(table: table, column: column)

    [:ok, value: inner_record[ctx[:data_array_idx]]]
  end

  def self.get_data_array_idx(table:, column:)
    [:ok, data_array_idx: table[:columns_hash][column][:data_array_idx]]
  end

  def self.deep_clone(table:, inner_records:, columns:)
    keys = table[:columns_hash].keys

    records = inner_records
      .map { |record| [keys, record.deep_dup].transpose.to_h }

    if columns
      records = records
        .map { |record| record.slice(*columns) }
    end

    [:ok, records: records]
  end

end