require 'uri'
require 'Rack'

module Kit::JsonApi::Services::Parser
  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.parse_url(url:)
    query_params_str = URI(url).query
    query_params     = Rack::Utils::parse_nested_query(query_params_str)

    parse_query_params(query_params: query_params)
  end

  def self.parse_query_params(query_params:)
    status, ctx = Kit::Organizer.call({
      list: [
        self.method(:parse_fields),
        self.method(:parse_sort),
        self.method(:parse_include),
        self.method(:parse_filter),
        self.method(:parse_page),
      ],
      ctx: {
        query_params_in:  query_params.deep_symbolize_keys,
        query_params_out: {},
      },
    })

    [:ok, query_params: ctx[:query_params_out]]
  end

  # @ex GET /authors?fields[authors]=name,date_of_birth&fields[books]=title
  # @ref https://jsonapi.org/format/1.1/#fetching-sparse-fieldsets
  def self.parse_fields(query_params_in:, query_params_out:)
    list = {}
    data = query_params_in[:fields] || {}

    data.each do |type_name, fields|
      list[type_name] = fields.split(',').map(&:to_sym)
    end

    query_params_out[:fields] = list

    [:ok, query_params_out: query_params_out]
  end

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

      if sid.include?('.')
        path, sid = sid.reverse.split(".", 2).map(&:reverse).reverse
      else
        path = :toplevel
      end

      list[path] ||= []
      list[path] << [sign, sid.to_sym]
    end

    query_params_out[:sort] = list

    [:ok, query_params_out: query_params_out]
  end

  # @ex GET /authors/1?include=books.chapters,photos
  # @ref https://jsonapi.org/format/1.1/#fetching-includes
  def self.parse_include(query_params_in:, query_params_out:)
    data = (query_params_in[:include] || '').split(',')

    query_params_out[:include] = data

    [:ok, query_params_out: query_params_out]
  end

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

      if path.include?('.')
        path, name = path.reverse.split(".", 2).map(&:reverse).reverse
      else
        path = :top_level
        name = path
      end
      filter[:name] = name.to_sym

      if val.is_a?(Hash)
        filter[:value] = val.values[0]
        filter[:op]    = val.keys[0].to_sym
      else
        filter[:value] = val
      end
      filter[:value] = filter[:value].split(',')

      if !filter[:op]
        filter[:op] = (filter[:value].size == 1) ? :eq : :in
      end

      list[path] ||= []
      list[path] << filter
    end

    query_params_out[:filter] = list

    [:ok, query_params_out: query_params_out]
  end


  # @ref https://jsonapi.org/format/1.1/#fetching-pagination
  # @ref https://jsonapi.org/profiles/ethanresnick/cursor-pagination/
  def self.parse_page(query_params_in:, query_params_out:)
    data = query_params_in[:page] || {}
    list = {}

    data.each do |attr_name, val|
      if attr_name.in?(['after', 'before', 'size'])
        list[:top_level] ||= {}
        list[:top_level][attr_name.to_sym] = val
      else
        list[attr_name] = val
      end
    end

    [:ok, query_params_out: query_params_out]
  end

end