module Kit::Pagination::ActiveRecord
  class << self

    # where("created_at >= :start_date AND created_at <= :end_date", {start_date: params[:start_date], end_date: params[:end_date]})
    def to_where_arguments(conditions:)
      [
        to_string(condition: conditions),
        to_values_hash(condition: conditions),
      ]
    end

    def to_order_arguments(ordering:)
      [ordering]
    end

    protected

    OperatorsStr = {
      lt:  '<',
      lte: '<=',
      gt:  '>',
      gte: '>=',
      and: '&&',
      or:  '||',
    }

    def to_string(condition:)
      condition = condition.dup

      if condition.is_a?(Kit::Pagination::Conditions::Set)
        values = condition
          .values
          .map { |value| value.is_a?(String) ? value : to_string(condition: value) }

        "(#{ values.join(" #{OperatorsStr[condition.operator]} ") })"

      elsif condition.is_a?(Kit::Pagination::Conditions::Single)
        "(#{condition.name} #{OperatorsStr[condition.operator]} :#{condition.name}_value)"
      end
    end

    def to_values_hash(condition:)
      condition = condition.dup

      if condition.is_a?(Kit::Pagination::Conditions::Set)
        condition
          .values
          .reduce({}) do |hash, value|
            hash.merge(value.is_a?(Hash) ? value : to_values_hash(condition: value))
          end

      elsif condition.is_a?(Kit::Pagination::Conditions::Single)
        { "#{condition.name}_value".to_sym => condition.value }
      end
    end

  end
end