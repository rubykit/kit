# Generate conditions for after / before cursors
module Kit::Pagination::Condition

  # Generate a condition Hash to retrieve elements after the original cursor element.
  #
  # The cursor might contain meta information to include the original element in the condition.
  def self.condition_for_after(ordering:, cursor_data:)
    condition = query_data(
      position:    :after,
      ordering:    ordering,
      cursor_data: cursor_data,
    )

    [:ok, condition: condition]
  end

  # Generate a condition Hash to retrieve elements before the original cursor element.
  #
  # The cursor might contain meta information to include the original element in the condition.
  def self.condition_for_before(ordering:, cursor_data:)
    condition = query_data(
      position:    :before,
      ordering:    ordering,
      cursor_data: cursor_data,
    )

    [:ok, condition: condition]
  end

  # @api private
  OPERATORS_MAPPING = {
    after:  {
      asc:  {
        last:     :gt,
        not_last: :gte,
      },
      desc: {
        last:     :lt,
        not_last: :lte,
      },
    },
    before: {
      asc:  {
        last:     :lt,
        not_last: :lte,
      },
      desc: {
        last:     :gt,
        not_last: :gte,
      },
    },
  }

  # Generate a condition from `cursor_data` and `ordering`.
  # @api private
  def self.query_data(ordering:, cursor_data:, position:, included_field_name: :_inc)
    included_in_set = (cursor_data[included_field_name] == true)

    or_values = ordering.each_with_index.map do |_, idx|
      and_values = (0..idx).map do |sub_idx|
        last = (sub_idx == idx) ? :last : :not_last
        # Account for cursor where the original element is meant to be included in the set.
        last = :not_last if last == :last && included_in_set

        name, order = ordering[sub_idx]
        value       = cursor_data[name]
        op          = OPERATORS_MAPPING[position][order][last]

        { name: name, op: op, values: value }
      end

      { op: :and, values: and_values }
    end

    { op: :or, values: or_values }
  end

end
