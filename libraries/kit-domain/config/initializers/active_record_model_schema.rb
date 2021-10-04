module ActiveRecord # rubocop:disable Style/Documentation
end

module ActiveRecord::ModelSchema # rubocop:disable Style/Documentation
end

# Reference:
# - https://github.com/rails/rails/blob/master/activerecord/lib/active_record/model_schema.rb
module ActiveRecord::ModelSchema::ClassMethods

  def allowed_columns
    @allowed_columns
  end

  def allowed_columns=(columns)
    @allowed_columns = columns.map(&:to_s)
  end

  def ensure_allowed_columns!
    return if self.in?([
      ActiveRecord::SchemaMigration,
      ActiveRecord::InternalMetadata,
    ])

    return if !@allowed_columns && !(respond_to?(:columns_allowlist) && columns_allowlist)

    if !defined?(@allowed_columns)
      @allowed_columns = []
    end

    if @allowed_columns.size > 0 || (respond_to?(:columns_allowlist) && columns_allowlist)
      @columns_hash.slice!(*@allowed_columns)
    end
  end

  # REF: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/model_schema.rb#L484
  def load_schema!
    @columns_hash = connection.schema_cache.columns_hash(table_name).except(*ignored_columns)

    ensure_allowed_columns!

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
