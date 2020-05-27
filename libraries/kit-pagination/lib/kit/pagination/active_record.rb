# Logic to generate ActiveRecord compatible parameters
module Kit::Pagination::ActiveRecord

  # Generate interpolation string + values hash that can be used in ActiveRecord's `where`.
  #
  # Examples:
  # ```irb
  # cursor_data = { id: 1, first: 'A', last: 'W' }
  # ordering    = [[:first, :asc], [:last, :desc], [:id, :asc]]
  # condition   = Kit::Pagination::Conditions.conditions_for_after(ordering: ordering, cursor_data: cursor_data)[1][:condition]
  #
  # to_where_arguments(conditions: condition)
  # [
  #   "(((first > :first_value)) OR ((first >= :first_value) AND (last < :last_value)) OR ((first >= :first_value) AND (last <= :last_value) AND (id > :id_value)))",
  #   { first_value: 'A', last_value: 'W', id: 1 },
  # ]
  #
  # ```
  def self.to_where_arguments(condition:)
    [
      to_string(condition: condition),
      to_values_hash(condition: condition),
    ]
  end

  # Generate ordering hash that can be used in ActiveRecord's `order`.
  def self.to_order_arguments(ordering:)
    [ordering.to_h]
  end

  # @api private
  OperatorsStr = {
    lt:  '<',
    lte: '<=',
    gt:  '>',
    gte: '>=',
    and: 'AND',
    or:  'OR',
  }

  # @api private
  def self.to_string(condition:)
    condition = condition.dup

    if [:and, :or].include?(condition[:op])
      values = condition[:values]
        .map { |value| value.is_a?(String) ? value : to_string(condition: value) }

      "(#{ values.join(" #{ OperatorsStr[condition[:op]] } ") })"

    #elsif condition.is_a?(Kit::Pagination::Conditions::Single)
    else
      "(#{ condition[:name] } #{ OperatorsStr[condition[:op]] } :#{ condition[:name] }_value)"
    end
  end

  # @api private
  def self.to_values_hash(condition:)
    condition = condition.dup

    if [:and, :or].include?(condition[:op])
      condition[:values]
        .reduce({}) do |hash, value|
          hash.merge(!value[:op] ? value : to_values_hash(condition: value))
        end
    else
      { "#{ condition[:name] }_value".to_sym => condition[:values] }
    end
  end

end
