# Generate LIMIT sql string statement.
module Kit::JsonApi::Services::Sql::Limit

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[limit: Ct::Optional[Ct::Integer]]
  after  Ct::Hash[sanitized_limit_sql: Ct::String]
  def self.limit_to_sql_str(sorting:)
  end

end
