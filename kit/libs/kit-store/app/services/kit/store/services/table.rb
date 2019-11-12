module Kit::Store::Services::Table

  def self.select(store:, from:, select:, where: [], limit: nil, order: nil)
    arguments = { store: store, from: from, select: select, where: where, limit: limit, order: order, }

    Kit::Store::Services::Table::Structure.select(arguments)
  end

  def self.insert(store:, table_name:, data:)
    arguments = { store: store, table_name: table_name, data: data, }

    status, ctx = Kit::Organizer.call({
      list: [
        Kit::Store::Services::Table::Structure.method(:get_table),
        Kit::Store::Services::Table::Insertion.method(:insert),
      ],
      ctx: arguments
    })

    [status, store: store, errors: ctx[:errors]]
  end

  # --------------------------------------------------------------------------

  def self.create(store:, table_name:)
    arguments = { store: store, table_name: table_name, }
    Kit::Store::Services::Table::Structure.create_table(arguments)
  end

  # NOTE: should foreign key go through here ?
  def self.add_column(store:, table_name:, column_name:, column_type:)
    arguments = { store: store, table_name: table_name, column_name: column_name, column_type: column_type, }

    status, ctx = Kit::Organizer.call({
      list: [
        Kit::Store::Services::Table::Structure.method(:get_table),
        Kit::Store::Services::Table::Structure.method(:add_column),
      ],
      ctx: arguments,
    })

    [status, store: store, errors: ctx[:errors]]
  end

  def self.add_unique_constraint(store:, table_name:, columns:, predicate: nil)
    arguments = { store: store, table_name: table_name, columns: columns, predicate: predicate }

    Kit::Store::Services::Table::Structure.add_unique_constraint(arguments)
  end

end
