# Handles records ordering.
module Kit::Store::Services::Table::Ordering

  include Kit::Contract
  # @hide true
  Ct = Kit::Store::Contracts

  # Sort `InnerRecods` by criterias provided as order like `[[:id, :desc], [:created_at, :asc]]`
  contract Ct::Hash[table: Ct::Table, inner_records: Ct::InnerRecords, order: Ct::Orders] => Ct::Tupple[Ct::Eq[:ok], Ct::Hash[inner_records: Ct::InnerRecords]]
  def self.order_by(table:, inner_records:, order: [])
    ordered_inner_records = inner_records.sort do |el1, el2|
      result = 0

      order.each do |attr_name, direction|
        _, el1_get = Kit::Store::Services::Table::Selection.get(table: table, inner_record: el1, column_name: attr_name)
        _, el2_get = Kit::Store::Services::Table::Selection.get(table: table, inner_record: el2, column_name: attr_name)
        el1_value  = el1_get[:value]
        el2_value  = el2_get[:value]
        res        = (direction == :asc) ? (el1_value <=> el2_value) : (el2_value <=> el1_value)

        if res != 0
          result = res
          break
        end
      end

      result
    end

    [:ok, inner_records: ordered_inner_records]
  end

end
