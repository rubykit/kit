# `Kit::Api::JsonApi` supports:
# - sorting on the top level collection and any to-many nested relationship
# - multiple sorting criterias per path
#
# A relationship that is traversed through multiple paths can have per-path sorting.
#
# Sorting criterias do not necessarily need to correspond to resource attribute and relationship names.
#
# ## URL format
#
# The format for sorting is:
# ```kit-url
#  GET https://my.api/my-resource?sort=(+|-)(resource_path.)sorting_criteria
# ```
#
# If the `resource_path` is omitted, the sorting criteria applies to the top level resource.
#
# If the sign is omitted, is defaults to `+`
# ```kit-url
# # The two following are equal
# GET /authors?sort=name
# GET /authors?sort=+name
# ```
#
# ## References
# - https://jsonapi.org/format/1.1/#fetching-sorting
#
module Kit::Api::JsonApi::Services::Request::Import::Sorting

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  # Entry point. Parse & validate sorting data before adding it to the `Request`.
  def self.handle_sorting(query_params:, request:)
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

  # Extract `sort` query-param and transform it into a normalized hash.
  #
  # ## Examples
  #
  # ```irb
  # irb> ex_qp  = 'authors?sort=-name,books.date_published,date_of_birth,-books.title'
  # irb> _, ctx = Services::Url.parse_query_params(url: "scheme://my.api/my-resource?#{ ex_qp }")
  # irb> ctx[:query_params]
  # {
  #   sort: '-name,books.date_published,date_of_birth,-books.title',
  # }
  # irb> _, ctx = parse(query_params: ctx[:query_params])
  # irb> ctx[:parsed_query_params_include]
  # {
  #   authors: [
  #     { sort_name: 'name',           direction: :desc },
  #     { sort_name: 'date_of_birth',  direction: :asc  },
  #   ],
  #   :'authors.books' => [
  #     { sort_name: 'date_published', direction: :asc  },
  #     { sort_name: 'title',          direction: :desc },
  #   ],
  # }
  # ```
  def self.parse(query_params:)
    data = (query_params[:sort] || '').split(',')
    list = {}

    data.each do |sid|
      if sid[0] == '-' || sid[0] == '+'
        sign = sid[0]
        sid  = sid[1..]
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
      list[path] << { sort_name: sid.to_sym, direction: direction }
    end

    [:ok, parsed_query_params_sort: list]
  end

  # Ensure that:
  # - nested relationships are included when sorted on
  # - sort criterias exist
  #
  # **⚠️ Warning**: in order to validate inclusion, the related resources need to have been run first.
  def self.validate(parsed_query_params_sort:, request:)
    errors = []

    parsed_query_params_sort.each do |path, list|
      if path == :top_level
        resource = request[:top_level_resource]
      else
        resource = request[:related_resources][path]
      end

      if !resource
        errors << { detail: "Sort: `#{ path }` is not an included relationship" }
        next
      end

      list.each do |direction:, sort_name:|
        sorter = resource[:sort_fields][sort_name.to_sym]
        if !sorter
          if path == :top_level
            detail = "Sort: `#{ sort_name }` is not a valid sorting criteria"
          else
            detail = "Sort: `#{ path }.#{ sort_name }` is not a valid sorting criteria"
          end
          errors << { detail: detail }
        end
      end

      # TODO: add restriction if only one order is valid?
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      [:ok]
    end
  end

  # When sorting data is valid, add it to the `Request`.
  def self.add_to_request(parsed_query_params_sort:, request:)
    request[:sorting] = parsed_query_params_sort

    [:ok, request: request]
  end

end
