# Transform sorting parameters from the AST to a SQL string
module Kit::JsonApi::Services::Sql::Sorting

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[sorting: Ct::Optional[Ct::SortOrders], table_name: Ct::String]
  after  Ct::Result[sanitized_sorting_sql: Ct::String]
  def self.sorting_to_sql_str(sorting:, table_name:)
    return true if !sorting || sorting.size == 0

    str = sorting
      .map { |column_name, sort_order| "#{ table_name }.#{ column_name } #{ sort_order.to_s.upcase }" }
      .join(', ')

    [:ok, sanitized_sorting_sql: str]
  end

end
