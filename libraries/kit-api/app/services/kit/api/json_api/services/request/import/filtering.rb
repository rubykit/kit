# `JSON:API` base specification is agnostic about filtering strategies supported by a server.
#
# `Kit::Api::JsonApi` supports:
# - filtering on the top level collection and any to-many relationship
# - multiple operators per field, defined per field type
#
# `Kit::Api::JsonApi` supports pagination on each included relationship.
# A relationship that is traversed through multiple paths can have per-path filters.
#
# ## URL format
#
# The format of a filter is:
# ```kit-url
#  GET https://my.api/my-resource?filter[(resource_path.)filter_name]([operator])=value(s)
# ```
#
# If the `resource_path` is omitted, the filter applies to the top level resource.
# ```kit-url
# # Implicit: the filter `name` is applied on `authors`
# GET /authors?filter[name]=Dan
# # Explicit: the filter `title` is applied on `books.chapter`
# GET /authors?include=books.chapter&filter[books.chapter.title]=Strider
# ```
#
# If the operator is omitted, is defaults to `eq` or `in`, based on the values.
# ```kit-url
# # Single value: the two following are equal
# GET /authors?filter[id]=2
# GET /authors?filter[id][eq]=2
#
# # Multiple values: the two following are equal
# GET /authors?filter[id]=1,2
# GET /authors?filter[id][in]=1,2
# ```
#
# ### ⚠️ Warning
#
# Filters on relationship **do not** have any effect on the parent (upper level).
# This ensures `Resources` can be loaded from different datasources, where JOINs are not available.
#
# ```kit-url
# # The following will not affect the returned authors, only the books.
# GET /authors?filter[books.title]=Title
# ```
#
# ## References
# - https://jsonapi.org/format/1.1/#fetching-filtering
# - https://jsonapi.org/recommendations/#filtering
#
module Kit::Api::JsonApi::Services::Request::Import::Filtering

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  # Entry point. Parse & validate filtering data before adding it to the `Request`.
  def self.handle_filtering(query_params:, request:)
    args = { query_params: query_params, request: request }

    Kit::Organizer.call({
      list: [
        self.method(:parse),
        self.method(:validate),
        self.method(:add_to_request),
      ],
      ctx:  args,
    })
  end

  # Extract `filter` query params and transform it into a normalized hash.
  #
  # ## Examples
  #
  # ```irb
  # irb> ex_qp  = "filter[name][eq]=Tolkien,Rowling&filter[books.date_published][lt]=2002&filter[date_of_birth][gt]=1950&filter[books.title]=Title"
  # irb> _, ctx = Services::Url.parse_query_params(url: "scheme://my.api/my-resource?#{ ex_qp }")
  # irb> ctx[:query_params]
  # {
  #   filter: {
  #     :name                   => { eq: 'Tolkien,Rowling' },
  #     :'books.date_published' => { lt: '2002' },
  #     :date_of_birth          => { gt: '1950' },
  #     :'books.title'          => "Title" },
  #   },
  # }
  # irb> _, ctx = parse(query_params: ctx[:query_params])
  # irb> ctx[:parsed_query_params_filters]
  # {
  #   :top_level => [
  #     { name: :name,           op: :in, value: ['Tolkien', 'Rowling'] },
  #     { name: :date_of_birth,  op: :gt, value: ['1950'] },
  #   ],
  #   'books'    => [
  #     { name: :date_published, op: :lt, value: ['2002'] },
  #     { name: :title,          op: :eq, value: ['Title'] },
  #   ],
  # }
  # ```
  def self.parse(query_params:)
    data = query_params[:filter] || {}
    list = {}

    data.each do |path, val|
      filter = { name: nil, op: nil, value: nil }
      path   = path.to_s

      if path.include?('.')
        path, name = path.reverse.split('.', 2).map(&:reverse).reverse
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

    [:ok, parsed_query_params_filters: list]
  end

  # Ensure that:
  # - nested relationships are included when filtered on
  # - filters types are supported on the fields
  #
  # **⚠️ Warning**: in order to validate inclusion, the related resources need to have been run first.
  def self.validate(parsed_query_params_filters:, request:)
    errors = []

    parsed_query_params_filters.each do |path, list|
      if path == :top_level
        resource = request[:top_level_resource]
      else
        resource = request[:related_resources][path]
      end

      if !resource
        errors << { detail: "Filter: `#{ path }` is not an included relationship" }
        next
      end

      list.each do |name:, op:, value:|
        operators  = resource[:filters][name.to_sym]
        error_path = (path == :top_level) ? "#{ name }" : "#{ path }.#{ name }"

        if !operators
          errors << { detail: "Filter: `#{ error_path }` is not a valid filter" }
        elsif !op.in?(operators)
          errors << { detail: "Filter: `#{ error_path }` does not support operator `#{ op }`" }
        end
      end
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      [:ok]
    end
  end

  # When filtering data is valid, add it to the `Request`.
  def self.add_to_request(parsed_query_params_filters:, request:)
    request[:filters] = parsed_query_params_filters

    [:ok, request: request]
  end

end
