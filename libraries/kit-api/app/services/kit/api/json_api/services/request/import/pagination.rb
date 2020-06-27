# `JSON:API` base specification is agnostic about pagination strategies supported by a server, it only reserves the `page` query parameter family for pagination.
#
# `Kit::Api::JsonApi` provides pagination strategies through `Paginators`.
#
# `Paginators` are set by `Resource` (types). ALthough not recommended, we support using different types of `Paginators` for different `Resources` in the same API.
#
# `Kit::Api::JsonApi` includes the following strategies:
# - [x] cursor based pagination strategy
# - [x] offset based pagination strategy
#
# ## URL format
#
# Regardless of the pagination strategy, the expected format is:
# ```kit-url
#  GET https://my.api/my-resource?page[(resource_path.)pagination_keyword]=cursor_data
# ```
# When the `resource_path` is omitted, pagination applies to the top level resource.
#
# Each pagination strategy defines the `pagination_keyword` it accepts.
#
# Note that `resource_path` only reference `relationship` names, and not `Resource` name.
# ```kit-url
#  # Here the pagination data apply to the top level Resource (books)
#  GET https://my.api/books?page[next]=cursor_data
#  # Here the pagination data apply to a relationship on the top level Resource (books),
#  #  with the name `books`, that can potentially map to any Resource type.
#  #  As this is quite confusing, it is recommended not to do it.
#  GET https://my.api/books?page[books.next]=cursor_data
# ```
#
# ## Considerations for different strategies
#
# Pagination strategies may have different implications for data `Resolvers`.
#
# Please check the documentation of the `Paginator` you wish to use.
#
# ## References
# - https://jsonapi.org/format/1.1/#fetching-pagination
# - https://jsonapi.org/profiles/ethanresnick/cursor-pagination/
#
module Kit::Api::JsonApi::Services::Request::Import::Pagination

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  # Entry point. Parse & validate pagination data before adding it to the `Request`.
  def self.handle_pagination(query_params:, api_request:)
    args = { query_params: query_params, api_request: api_request }

    Kit::Organizer.call({
      list: [
        self.method(:parse),
        self.method(:validate),
        self.method(:run_paginators_import),
        self.method(:add_to_api_request),
      ],
      ctx:  args,
    })
  end

  # Extract `page` query params and transform it into a normalized & per-path hash.
  #
  # ## Examples
  #
  # ```irb
  # irb> ex_qp  = "include=books.chapters&page[size]=2&page[after]=XdJ6Fh&page[books.size]=3&page[books.offset]=4&page[books.chapters.size]=4"
  # irb> _, ctx = Services::Url.parse_query_params(url: "scheme://my.api/my-resource?#{ ex_qp }")
  # irb> ctx[:query_params]
  # {
  #   include: 'books.chapters',
  #   page:    {
  #     :size                  => '2',
  #     :after                 =>'XdJ6Fh',
  #     :"books.size"          => '3',
  #     :"books.offset"        => '2',
  #     :"books.chapters.size" => '4',
  #   },
  # }
  # irb> _, ctx = parse(query_params: ctx[:query_params])
  # irb> ctx[:parsed_query_params_page]
  # {
  #   :top_level        => {
  #     size:  '2',
  #     after: 'XdJ6Fh'
  #   },
  #   :'books'          => {
  #     size:   '3',
  #     offset: '2',
  #   },
  #   :'books.chapters' => {
  #     size:   '4',
  #   },
  # }
  # ```
  def self.parse(query_params:)
    data = query_params[:page] || {}
    list = {}

    data.each do |path, value|
      path = path.to_s

      if path.include?('.')
        path, keyword = path.reverse.split('.', 2).map(&:reverse).reverse
      else
        keyword = path
        path    = :top_level
      end
      keyword = keyword.to_sym

      list[path]          ||= {}
      list[path][keyword] ||= []
      list[path][keyword] += value.split(',')
    end

    [:ok, parsed_query_params_page: list]
  end

  # Ensure that:
  # - nested relationships are included when paginated on
  #
  # Everything else is the responsability of each Paginator.
  #
  # **⚠️ Warning**: in order to validate inclusion, the related resources need to have been run first.
  def self.validate(api_request:, parsed_query_params_page:)
    errors = []

    parsed_query_params_page.each do |path, _list|
      resource = (path == :top_level) ? api_request[:top_level_resource] : api_request[:related_resources][path]

      if !resource
        errors << { detail: "Page: `#{ path }` is not an included relationship" }
      end
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      [:ok]
    end
  end

  # Find all paginators in use for the Request and run their validation logic.
  def self.run_paginators_import(api_request:, parsed_query_params_page:)
    paginators = {}

    # Sort parsed_query_params per paginator type
    parsed_query_params_page.each do |path, list|
      resource  = (path == :top_level) ? api_request[:top_level_resource] : api_request[:related_resources][path]
      container = paginators[resource[:paginator][:type]] ||= { paginator: resource[:paginator], parsed_query_params_page: {} }
      container[:parsed_query_params_page][path] = list
    end

    # Call each paginator with its data
    paginators.each do |_paginator_type, paginator_data|
      paginator   = paginator_data[:paginator]
      result      = paginator[:import].call(api_request: api_request, parsed_query_params_page: paginator_data[:parsed_query_params_page])
      status, ctx = result

      return result if status == :error

      ctx[:parsed_query_params_page].each do |pqpp_path, pqpp_data|
        parsed_query_params_page[pqpp_path] = pqpp_data
      end
    end

    [:ok, parsed_query_params_page: parsed_query_params_page]
  end

  # When pagination data is valid, add it to the `Request`.
  def self.add_to_api_request(parsed_query_params_page:, api_request:)
    api_request[:pagination] = parsed_query_params_page

    [:ok, api_request: api_request]
  end

end
