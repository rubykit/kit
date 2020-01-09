module Kit::JsonApi::Services::Sql::Filtering
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  OperatorsStr = {
    lt:  '<',
    lte: '<=',
    gt:  '>',
    gte: '>=',
    in:  'IN',
    and: 'AND',
    or:  'OR',
  }

  before Ct::Hash[ar_connection: Ct::Any, filtering: Ct::Optional[Ct::Condition]]
  #after  Ct::Success[sanitized_filtering_sql: Ct::String]
  def self.filtering_to_sql_str(filtering:, ar_connection:)
    args = { filtering: filtering, ar_connection: ar_connection, }
    if filtering == nil
      return [:ok, sanitized_filtering_sql: 'true']
    end

    Kit::Organizer.call({
      list: [
        self.method(:filter_to_presanitized_sql),
        [:wrap, Kit::JsonApi::Services::Sql::Sanitization.method(:sanitize_sql),
          in:  { :presanitized_sql  => :statement, :hash_values => :values, :ar_connection => :ar_connection, },
          out: { :sanitized_sql_str => :sanitized_filtering_sql, },
        ],
      ],
      ctx: args,
    })
  end

  # Reduce `Ct::Conditions` to a pre-sanitized string and corresponding hash values
  # @todo Sanitize `column` names (not sure if useful)
  before Ct::Hash[filtering: Ct::Condition]
  def self.filter_to_presanitized_sql(filtering:)
    filter   = filtering.dup
    operator = filter[:op]
    column   = filter[:column]
    values   = filter[:values]

    hash_values  = {}
    sql_operator = OperatorsStr[operator]

    if operator.in?([:and, :or])
      str_values = values.map do |value|
        if value.is_a?(String)
          #hash_values[column] = value
          value
        else
          status, ctx = filter_to_presanitized_sql(filter: value)
          hash_values.merge!(ctx[:hash_values])
          ctx[:presanitized_sql]
        end
      end

      presanitized_sql = "(#{ str_values.join(" #{sql_operator} ") })"
    else
      hash_values[column] = values
      presanitized_sql = "(#{ column } #{ sql_operator } (:#{column}))"
    end

    [:ok, presanitized_sql: presanitized_sql, hash_values: hash_values]
  end

end