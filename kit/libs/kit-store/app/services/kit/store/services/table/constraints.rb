module Kit::Store::Services::Table::Constraints

  def self.apply_to_data(table:, data_hash:)
    [:ok]
  end

  def self.add_to_table(table:, callable:)
    table[:constraints] ||= {}
    table[:constraints] << callable

    if callable.respond_to?(:call)
      [:ok]
    else
      [:error, "Could not add constraint to table (not a callable)"]
    end
  end

end