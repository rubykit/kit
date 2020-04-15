module Kit::JsonApi::Services::Url::Parser::Filter
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  # The format of a filter is `filter[(path.)filter_name]([operator])=value(s)`.
  # If the path is ommited, it applies to the top level resource.
  # @ex /authors?filter[name]=Dan # The filter `name` is applied on `authors`
  # Otherwise it applies to the related resource.
  # @ex /authors?include=books.chapter&filter[books.chapter.title]=Strider # The filter `title` is applied on `books.chapter`
  # If the operator is ommited, is defaults to `in` (similar to `eq` for single value).
  # @ex /authors?filter[id]=2 is equal to /authors?filter[id][eq]=2
  # @ex /authors?filter[id]=1,2 is equal to /authors?filter[id][in]=1,2
  # Multiple values are treated as an implicit `OR`.
  # @ex /authors?filter[name][contains]=Tolkien&filter[books.id]=1,2
  # @ref https://jsonapi.org/format/1.1/#fetching-filtering
  # @ref https://jsonapi.org/recommendations/#filtering
  # @warning Filters on relationship DO NOT modify the parent set. /authors?filter[books.title]=Title WILL NOT affect the returned authors, only the books relationship. This ensures Resources can be loaded from different datasources (no join available).
  def self.parse_filter(query_params_in:, query_params_out:)
    data = query_params_in[:filter] || {}
    list = {}

    data.each do |path, val|
      filter = { name: nil, op: nil, value: nil }
      path   = path.to_s

      if path.include?('.')
        path, name = path.reverse.split(".", 2).map(&:reverse).reverse
      else
        name = path
        path = :top_level
      end
      filter[:name] = name.to_sym

      if val.is_a?(Hash)
        filter[:value] = val.values[0]
        filter[:op]    = val.keys[0].to_sym
      else
        filter[:value] = val
      end
      filter[:value] = filter[:value].split(',')

      if !filter[:op] || filter[:op].in?([:eq, :in])
        filter[:op] = (filter[:value].size == 1) ? :eq : :in
      end

      list[path] ||= []
      list[path] << filter
    end

    query_params_out[:filter] = list

    [:ok, query_params_out: query_params_out]
  end

end