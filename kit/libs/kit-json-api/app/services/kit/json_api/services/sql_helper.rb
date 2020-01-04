module Kit::JsonApi::Services::SqlHelper
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  # @note The SQL is generated for Postgres. Probably needs to be tuned for other DBs.
  def self.generate_sql_query(ar_model:, filtering: [], sorting: [], limit: nil)
    sanitized_limit     = limit || 100
    sanitized_filtering = true
    sanitized_sorting   = Kit::JsonApi::Services::SqlHelper.sorting_to_sql_str(sorting: sorting)

    relationship_column = nil
    table_name          = ar_model.table_name

    if relationship_column
      # @note We use a nested query to avoid naming collisions with the added attribute (rank)
      # @ref https://blog.jooq.org/2018/05/14/selecting-all-columns-except-one-in-postgresql/
      # @ref http://sqlfiddle.com/#!17/378a3/10

      sql = %{
        SELECT (data).*
          FROM (
            SELECT data,
                   RANK() OVER (PARTITION BY #{relationship_column} ORDER BY #{sanitized_sorting}) AS rank
              FROM #{table_name} data
             WHERE #{sanitized_filtering}
               /* AND {query_conditions}
                  AND ({relationship_column_name} IN ({relationship_values.join(', ')}))
               */
               ) AS ranked_data
         WHERE ranked_data.rank <= #{sanitized_limit}
      }
    else
    # @note Avoid the window function (RANK) when not needed
      sql = %{
        SELECT *
          FROM #{table_name}
         WHERE #{sanitized_filtering}
      ORDER BY #{sanitized_sorting}
         LIMIT #{sanitized_limit}
      }
    end

    sql
  end


  before Ct::Hash[sorting: Ct::Optional[Ct::SortOrders]]
  def self.sorting_to_sql_str(sorting:)
    return true if !sorting || sorting.size == 0

    sorting
      .map { |column_name, sort_order| "#{column_name} #{sort_order.to_s.upcase}" }
      .join(', ')
  end

  OperatorsStr = {
    lt:  '<',
    lte: '<=',
    gt:  '>',
    gte: '>=',
    in:  'IN',
    and: 'AND',
    or:  'OR',
  }


  # Reduce `Ct::Conditions` to a pre-sanitized string and corresponding hash values
  # @todo Sanitize `column` names (not sure if useful)
  before Ct::Hash[filter: Ct::Condition]
  def self.filter_to_presanitized_sql(filter:)
    filter   = filter.dup
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
      presanitized_sql = "(`#{ column }` #{ sql_operator } (:#{column}))"
    end

    [:ok, presanitized_sql: presanitized_sql, hash_values: hash_values]
  end

  before Ct::Hash[filter: Ct::Condition]
  def self.filter_to_sql(filter:, ar_connection:)
    args = { filter: filter, ar_connection: ar_connection, }
    Kit::Organizer.call({
      list: [
        self.method(:filter_to_presanitized_sql),
        [:wrap,
          callable: Kit::JsonApi::Services::SqlSanitization.method(:sanitize_sql),
          in:  { :presanitized_sql => :statement, }
          out: { },
        ],
      ],
      ctx: args,
    })
  end

end