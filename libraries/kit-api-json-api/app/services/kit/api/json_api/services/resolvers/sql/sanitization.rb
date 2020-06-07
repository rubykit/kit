# @see https://github.com/rails/rails/blob/6-0-stable/activerecord/lib/active_record/sanitization.rb
module Kit::Api::JsonApi::Services::Resolvers::Sql::Sanitization

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

=begin
  # Sanitizes a +string+ so that it is safe to use within an SQL LIKE statement.
  # This method uses +escape_character+ to escape all occurrences of "\", "_" and "%".
  # @example sanitize_sql_like("100%") #=> "100\\%"
  # @example sanitize_sql_like("snake_cased_string") #=> "snake\\_cased\\_string"
  # @example sanitize_sql_like("100%", "!") #=> "100!%"
  # @example sanitize_sql_like("snake_cased_string", "!") #=> "snake!_cased!_string"
  def sanitize_sql_like(string:, escape_character: = "\\")
    pattern = Regexp.union(escape_character, "%", "_")
    string.gsub(pattern) { |x| [escape_character, x].join }
  end
=end

  # Sanitize and interpolate each value into the SQL statement.
  # @example sanitize_sql(statement: "name=:name and group_id=:group_id", values: { name: "foo'bar", group_id: 4 }) #=> "name='foo''bar' and group_id=4"
  before Ct::Hash[statement: Ct::String, values: Ct::Hash]
  after  Ct::Result[sanitized_sql_str: Ct::String]
  def self.sanitize_sql(statement:, values:, ar_connection:)
    return statement if statement.blank?

    sanitized_sql = statement.gsub(%r{(:?):([a-zA-Z]\w*)}) do |match|
      if $1 == ':' # skip postgresql casts
        match # return the whole match
      elsif values.include?(match = $2.to_sym)
        quote_bound_value(value: values[match], ar_connection: ar_connection)
      else
        return [:error, "SqlSanitization: missing value for :#{ match } in #{ statement }"]
      end
    end

    [:ok, sanitized_sql_str: sanitized_sql]
  end

  def self.quote_bound_value(value:, ar_connection:)
    if value.respond_to?(:map) && !value.acts_like?(:string)
      quoted = value.map { |v| ar_connection.quote(v) }
      if quoted.empty?
        ar_connection.quote(nil)
      else
        quoted.join(',')
      end
    else
      ar_connection.quote(value)
    end
  end

end
