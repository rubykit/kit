module ActiveRecord # rubocop:disable Style/Documentation
end

module ActiveRecord::ModelSchema # rubocop:disable Style/Documentation
end

# Reference:
# - https://github.com/rails/rails/blob/master/activerecord/lib/active_record/model_schema.rb
module ActiveRecord::ModelSchema::ClassMethods

  def whitelisted_columns
    @whitelisted_columns
  end

  def whitelisted_columns=(columns)
    @whitelisted_columns = columns.map(&:to_s)
  end

  def ensure_whitelisted_columns!
    return if self.in?([
      ActiveRecord::SchemaMigration,
      ActiveRecord::InternalMetadata,
    ])

    return if !@whitelisted_columns && !(respond_to?(:columns_whitelisting) && columns_whitelisting)

    if !defined?(@whitelisted_columns)
      @whitelisted_columns = []
    end

    if @whitelisted_columns.size > 0 || (respond_to?(:columns_whitelisting) && columns_whitelisting)
      @columns_hash.slice!(*@whitelisted_columns)
    end
  end

  # REF: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/model_schema.rb#L484
  def load_schema!
    @columns_hash = connection.schema_cache.columns_hash(table_name).except(*ignored_columns)

    ensure_whitelisted_columns!

    @columns_hash.each do |name, column|
      define_attribute(
        name,
        connection.lookup_cast_type_from_column(column),
        default:               column.default,
        user_provided_default: false,
      )
    end
  end

end
