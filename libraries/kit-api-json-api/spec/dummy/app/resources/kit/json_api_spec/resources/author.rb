# Exemple type for dummy app.
module Kit::JsonApiSpec::Resources::Author

  include Kit::Api::JsonApi::Resources::ActiveRecordResource

  def self.name
    :author
  end

  def self.model
    Kit::JsonApiSpec::Models::Write::Author
  end

  def self.fields_setup
    {
      id:            { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at:    { type: :date },
      updated_at:    { type: :date },
      name:          { type: :string },
      date_of_birth: { type: :date },
      date_of_death: { type: :date, sort_field: { order: :desc } },
    }
  end

  def self.filters
    # Dummy filter, acts as an exemple of a custom filter.
    super.merge({
      alive: Kit::Api::JsonApi::Resources::ActiveRecordResource.default_filters[:boolean],
    })
  end

  def self.relationships
    {
      books:  {
        resource:          :book,
        relationship_type: :to_many,
        resolver:          [:active_record, foreign_key_field: :kit_json_api_spec_author_id],
      },
      photos: {
        resource:          :photo,
        relationship_type: :to_many,
        resolver:          [:active_record, foreign_key_field: [:imageable_id, :imageable_type, 'Kit::JsonApiSpec::Models::Write::Author']],
      },
      series: {
        resource:          :serie,
        relationship_type: :to_many,
        resolver:          {
          inherited_filter: Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.inherited_filter_to_many(field_name: 'kit_json_api_spec_books.kit_json_api_spec_author_id'),
          records_selector: Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.records_selector_to_many(field_name: :kit_json_api_spec_author_id),
          data_resolver:    Kit::Api::JsonApi::Services::Resolvers::Data::ActiveRecord.generate_data_resolver({
            model:              Kit::JsonApiSpec::Models::Write::Serie,
            assemble_sql_query: self.method(:assemble_series_relationship_sql_query),
          }),
        },
      },
    }
  end

  # Note: we might want to add helpers to handle JOINs. Or leave it as is as an exemple since it's something we want to discourage.
  def self.assemble_series_relationship_sql_query(table_name:, sanitized_filtering_sql:, sanitized_sorting_sql:, sanitized_limit_sql:, foreign_key_column_name: nil)
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

=begin
  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Author::Relationships::Books,
      Kit::JsonApiSpec::Resources::Author::Relationships::Photos,
      Kit::JsonApiSpec::Resources::Author::Relationships::Series,
    ]

    list
      .map { |el| [el.relationship[:name], el.relationship] }
      .to_h
  end

  def self.resource_url(resource_id:)
    "/authors/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_name:)
    "/articles/#{ resource_id }/relationships/#{ relationship_name }"
  end
=end

end
