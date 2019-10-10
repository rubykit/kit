module Kit::Store::Services::Table
  module Ordering

    def self.order_by(table:, records:, order: [])
      :validate_ordering,
      :apply_ordering,
    end

    # `order` has to be in the form of [[:column_name1, (:asc || :desc)], [:column_name2, (:asc || :desc)], ...]
    def self.validate_ordering(table:, order:)
      errors = []

      if !order.is_a?(Array)
        valid = [:error, "Kit::Store | Table `#{table_name}` already exists"]
      end

      if valid.each do |content|
        column_name, direction = content


      end


    end

    def self.apply_ordering(table:, records:, order: [])
      ordered_records = records.sort do |el1, el2|
        result = 0

        order.each do |attr_name, direction|
          _, el1_get = get(table: table, row_data: el1, column: attr_name)
          _, el2_get = get(table: table, row_data: el2, column: attr_name)
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

      [:ok, records: ordered_records]
    end

  end
end