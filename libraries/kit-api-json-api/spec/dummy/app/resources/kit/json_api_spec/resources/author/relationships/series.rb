module Kit::JsonApiSpec::Resources::Author::Relationships::Series

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  after Ct::Relationship
  def self.relationship
    {
      name:                       :series,

      parent_resource:            -> { Kit::JsonApiSpec::Resources::Author.resource },
      child_resource:             -> { Kit::JsonApiSpec::Resources::Serie.resource },

      type:                       :to_many,

      inclusion_level:            1,

      inherited_filter:           ->(query_node:) do
        values = (query_node.dig(:parent_relationship, :parent_query_node, :records) || [])
          .map { |el| el[:raw_data] }
          .map { |el| el[:id] }
        if values.size > 0
          Kit::Api::JsonApi::Types::Condition[op: :in, column: :'kit_json_api_spec_books.kit_json_api_spec_author_id', values: values, upper_relationship: true]
        else
          nil
        end
      end,

      select_relationship_record: ->(parent_record:) do
        ->(child_record) { parent_record[:raw_data].id == child_record[:raw_data].read_attribute(:kit_json_api_spec_author_id) }
      end,

      data_loader:                self.method(:load_series_relationship_data),
    }
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :serie },
  ]
  def self.load_series_relationship_data(query_node:)
    ar_model = Kit::JsonApiSpec::Models::Write::Serie

    _, ctx = Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Sql::Filtering.method(:filtering_to_sql_str),
        Kit::Api::JsonApi::Services::Sql::Sorting.method(:sorting_to_sql_str),
        Kit::Api::JsonApi::Services::Sql.method(:detect_relationship),
        self.method(:generate_series_relationship_sql_query),
      ],
      ctx:  {
        filtering:           query_node[:condition],
        sorting:             query_node[:sorting],
        ar_connection:       ar_model.connection,
        table_name:          ar_model.table_name,
        sanitized_limit_sql: query_node[:limit].to_i.to_s,
      },
    })

    puts ctx[:sql_str]
    data = ar_model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA RS SERIE: #{ data.size }"

    [:ok, data: data]
  end

  def self.generate_series_relationship_sql_query(table_name:, sanitized_filtering_sql:, sanitized_sorting_sql:, sanitized_limit_sql:, foreign_key_column_name: nil)
    joined_table = 'kit_json_api_spec_books'
    sql = %{
      SELECT (#{ table_name }).*, kit_json_api_spec_author_id
        FROM (
          SELECT #{ table_name },
                 #{ foreign_key_column_name } AS kit_json_api_spec_author_id,
                 RANK() OVER (PARTITION BY #{ foreign_key_column_name } ORDER BY #{ sanitized_sorting_sql }) AS rank
            FROM #{ table_name }
            JOIN #{ joined_table } ON #{ joined_table }.kit_json_api_spec_serie_id = #{ table_name }.id
           WHERE #{ sanitized_filtering_sql }
        GROUP BY #{ table_name }.id, #{ foreign_key_column_name }
             ) AS ranked_data
       WHERE ranked_data.rank <= #{ sanitized_limit_sql }
    }

    puts sql

    [:ok, sql_str: sql]
  end

end
