require_relative 'comparable'

# Simulate DB behaviour
module SpecDb
  class << self

    def order(set:, ordering:)
      set.sort_by do |element|
        comparable_hash = ordering
          .map { |name, order| [element.send(name), order] }
          .to_h

        Comparable[comparable_hash]
      end
    end

    # Select element
    def select_after(ordered_set:, condition:, limit:)
      ordered_set
        .select { |element| obeys?(element: element, condition: condition) }
        .slice(0, limit)
    end

    def select_before(ordered_set:, condition:, limit:)
      select_after({
        ordered_set: ordered_set.reverse,
        condition:   condition,
        limit:       limit,
      }).reverse
    end

    protected

    # Check that an element obeys a number of "conditions" structs
    def obeys?(element:, condition:)
      conditions = conditions.dup

      # ConditionSet
      if condition.is_a?(Kit::Pagination::Conditions::Set)
        values = condition.values.map do |value|
          # Boolean (condition has already been checked)
          if [true, false].include?(value)
            value
          # Still a `condition` struct, needs to be resolved
          else
            obeys?(element: element, condition: value)
          end
        end

        if condition.operator == :and
          values.uniq == [true]
        else
          values.include?(true)
        end

      # Condition
      else
        value    = condition.value
        el_value = element.send(condition.name)

        case condition.operator
        when :lt
          el_value < value
        when :lte
          el_value <= value
        when :gt
          el_value > value
        when :gte
          el_value >= value
        end
      end
    end

  end

end