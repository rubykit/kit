module Kit::Store::Services::Table::Constraints
  include Kit::Contract
  Ct = Kit::Store::Contracts

  # Categories: types, uniqueness, foreign_keys

  contract Ct::Hash[table: Ct::Table, record: Ct::Record]
  def self.apply_to_record(table:, record:)
    #table[:constraints].each do |constraint|
      # ???
    #end

    [:ok, record: record]
  end

  contract Ct::Hash[table: Ct::Table, callable: Ct::Callable]
  def self.add_to_table(table:, callable:)
    table[:constraints] ||= {}
    table[:constraints] << callable

    [:ok]
  end

  contract Ct::Hash[table: Ct::Table, column_name: Ct::Callable]
  def self.add_uniqueness_constraint(table:, callable:)

    # ???

    add_to_table(
      table:    table,
      callable: callable,
    )

    [:ok]
  end

end