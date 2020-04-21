# Transform the `sort` query parameter into something usable.
module Kit::JsonApi::Services::Url::Parser::Sort

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  # For the given example, the following sorting is applied: { authors: [name DESC, date_of_birt ASC], books: [date_published ASC, title DESC] }
  # @ex GET /authors?sort=-name,books.date_published,date_of_birth,-books.title
  # @ref https://jsonapi.org/format/1.1/#fetching-sorting
  def self.parse_sort(query_params_in:, query_params_out:)
    data = (query_params_in[:sort] || '').split(',')
    list = {}

    data.each do |sid|
      if sid[0] == '-' || sid[0] == '+'
        sign = sid[0]
        sid  = sid[1..-1]
      else
        sign = '+'
      end

      direction = (sign == '+') ? :asc : :desc

      if sid.include?('.')
        path, sid = sid.reverse.split('.', 2).map(&:reverse).reverse
      else
        path = :top_level
      end

      list[path] ||= []
      list[path] << { direction: direction, sort_name: sid.to_sym }
    end

    query_params_out[:sort] = list

    [:ok, query_params_out: query_params_out]
  end

end
