# Transform AST to a SQL query string
module Kit::JsonApi::Services::Sql

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  # @note The SQL is generated for Postgres. Probably needs to be tuned for other DBs.
  def self.sql_query(ar_model:, filtering: nil, sorting: [], limit: nil)
    args = { ar_model: ar_model, filtering: filtering, sorting: sorting, limit: limit }

    status, ctx = Kit::Organizer.call({
      list: [
        Kit::JsonApi::Services::Sql::Filtering.method(:filtering_to_sql_str),
        Kit::JsonApi::Services::Sql::Sorting.method(:sorting_to_sql_str),
        self.method(:detect_relationship),
        self.method(:generate_sql_query),
      ],
      ctx:  args.merge({
        ar_connection:       ar_model.connection,
        table_name:          ar_model.table_name,
        sanitized_limit_sql: limit.to_i.to_s,
      }),
    })

    [status, ctx.slice(:sql_str, :errors)]
  end

  def self.detect_relationship(filtering:)
    detect = proc do |condition:|
      next if !condition

      if condition[:upper_relationship]
        return [:ok, foreign_key_column_name: condition[:column]]
      end

      if condition[:op].in?([:and, :or])
        condition[:values].each do |value|
          detect.call(condition: value)
        end
      end
    end

    detect.call(condition: filtering)

    [:ok]
  end

  def self.generate_sql_query(table_name:, sanitized_filtering_sql:, sanitized_sorting_sql:, sanitized_limit_sql:, foreign_key_column_name: nil)
    if foreign_key_column_name
      # @note Allow to query several subsets with their own ordering.
      # @note We use a nested query to avoid naming collisions with the added attribute (rank)
      # @see https://blog.jooq.org/2018/05/14/selecting-all-columns-except-one-in-postgresql/
      # @see http://sqlfiddle.com/#!17/378a3/10
      sql = %(
          SELECT (#{ table_name }).*
            FROM (
              SELECT #{ table_name },
                     RANK() OVER (PARTITION BY #{ foreign_key_column_name } ORDER BY #{ sanitized_sorting_sql }) AS rank
                FROM #{ table_name }
               WHERE #{ sanitized_filtering_sql }
                 ) AS ranked_data
           WHERE ranked_data.rank <= #{ sanitized_limit_sql }
        )
    else
      # @note Avoid the window function (RANK) when not needed.
      sql = %(
          SELECT *
            FROM #{ table_name }
           WHERE #{ sanitized_filtering_sql }
        ORDER BY #{ sanitized_sorting_sql }
           LIMIT #{ sanitized_limit_sql }
      )
    end

    [:ok, sql_str: sql]
  end

end
