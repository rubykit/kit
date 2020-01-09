module Kit::JsonApi::Services::Sql::Sorting
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  before Ct::Hash[ar_connection: Ct::Any, sorting: Ct::Optional[Ct::SortOrders]]
  #after  Ct::Hash[sanitized_sorting_sql: Ct::String]
  def self.sorting_to_sql_str(sorting:)
    return true if !sorting || sorting.size == 0

    str = sorting
      .map { |column_name, sort_order| "#{column_name} #{sort_order.to_s.upcase}" }
      .join(', ')

    [:ok, sanitized_sorting_sql: str]
  end

end