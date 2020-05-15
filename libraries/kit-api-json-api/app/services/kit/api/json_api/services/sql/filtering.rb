# Transform Conditions AST to a SQL string
module Kit::Api::JsonApi::Services::Sql::Filtering

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  OPERATORS_STR = {
    eq:  '=',
    lt:  '<',
    lte: '<=',
    gt:  '>',
    gte: '>=',
    in:  'IN',
    and: 'AND',
    or:  'OR',
  }

  before Ct::Hash[ar_connection: Ct::Any, filtering: Ct::Optional[Ct::Condition]]
  after  Ct::Result[sanitized_filtering_sql: Ct::String]
  def self.filtering_to_sql_str(filtering:, ar_connection:)
    args = { filtering: filtering, ar_connection: ar_connection }
    if filtering == nil
      return [:ok, sanitized_filtering_sql: 'true']
    end

    Kit::Organizer.call({
      list: [
        self.method(:filter_to_presanitized_sql),
        [:wrap, Kit::Api::JsonApi::Services::Sql::Sanitization.method(:sanitize_sql),
          in:  { presanitized_sql: :statement, hash_values: :values, ar_connection: :ar_connection },
          out: { sanitized_sql_str: :sanitized_filtering_sql },
        ],
      ],
      ctx:  args,
    })
  end

  # Reduce `Ct::Conditions` to a pre-sanitized string and corresponding hash values
  # @todo Sanitize `column` names (not sure if useful)
  before Ct::Hash[filtering: Ct::Condition]
  after  Ct::Result[presanitized_sql: Ct::String, hash_values: Ct::Hash]
  def self.filter_to_presanitized_sql(filtering:)
    filter   = filtering.dup
    operator = filter[:op]
    column   = filter[:column]
    values   = filter[:values]

    hash_values  = {}
    sql_operator = OPERATORS_STR[operator]

    if operator == :in
      values = values.uniq
    end

    if operator.in?([:and, :or])
      str_values = values.map do |value|
        if value.is_a?(String)
          #hash_values[column] = value
          value
        else
          _, ctx = filter_to_presanitized_sql(filtering: value)
          hash_values.merge!(ctx[:hash_values])
          ctx[:presanitized_sql]
        end
      end

      presanitized_sql = "(#{ str_values.join(" #{ sql_operator } ") })"
    else
      real_column_name = column
      safe_column_name = column.to_s.gsub('.', '__')
      hash_values[safe_column_name.to_sym] = values
      presanitized_sql = "(#{ real_column_name } #{ sql_operator } (:#{ safe_column_name }))"
    end

    [:ok, presanitized_sql: presanitized_sql, hash_values: hash_values]
  end

end
