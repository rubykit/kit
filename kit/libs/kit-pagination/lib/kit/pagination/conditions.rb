module Kit::Pagination::Conditions

  Single = Struct.new(:name, :operator, :value)
  Set    = Struct.new(:operator, :values)

  class << self

    def conditions_for_after(ordering:, cursor_data:)
      query_data(
        ordering:    ordering,
        cursor_data: cursor_data,
        action:      :after,
      )
    end

    def conditions_for_before(ordering:, cursor_data:)
      query_data(
        ordering:    ordering,
        cursor_data: cursor_data,
        action:      :before,
      )
    end

    protected

    def query_data(ordering:, cursor_data:, action:)
      or_values = ordering.each_with_index.map do |_, idx|
        and_values = (0..idx).map do |sub_idx|
          last        = (sub_idx == idx)
          name, order = ordering[sub_idx]
          value       = cursor_data[name]

          if action == :after
            operator = (order == :asc ? (last ? :gt : :gte) : (last ? :lt : :lte))
          else
            operator = (order == :asc ? (last ? :lt : :lte) : (last ? :gt : :gte))
          end

          Single.new(name, operator, value)
        end

        Set.new(:and, and_values)
      end

      Set.new(:or, or_values)
    end

  end
end
