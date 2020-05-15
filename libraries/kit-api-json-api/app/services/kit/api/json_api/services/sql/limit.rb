# Generate LIMIT sql string statement.
module Kit::Api::JsonApi::Services::Sql::Limit

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  before Ct::Hash[limit: Ct::Optional[Ct::Integer]]
  after  Ct::Hash[sanitized_limit_sql: Ct::String]
  def self.limit_to_sql_str(sorting:)
  end

end
