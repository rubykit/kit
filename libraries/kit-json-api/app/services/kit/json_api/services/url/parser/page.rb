# Transform the `page` query parameter into something usable.
module Kit::JsonApi::Services::Url::Parser::Page

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  # @see https://jsonapi.org/format/1.1/#fetching-pagination
  # @see https://jsonapi.org/profiles/ethanresnick/cursor-pagination/
  def self.parse_page(query_params_in:, query_params_out:)
    data = query_params_in[:page] || {}
    list = {}

    data.each do |path, _val|
      path = path.to_s

      if path.include?('.')
        path, type = path.reverse.split('.', 2).map(&:reverse).reverse
      else
        type = path
        path = :top_level
      end
      type = type.to_sym

      list[path]        ||= {}
      (list[path][type] ||= []) << value
    end

    query_params_out[:page] = list

    [:ok, query_params_out: query_params_out]
  end

end
