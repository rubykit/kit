# `JSON:API` base specification is agnostic about pagination strategies supported by a server, it only reserves the `page` query parameter family for pagination.
#
# `Kit::Api::JsonApi` supports:
# - [x] cursor based pagination strategy (add link)
# - [ ] offset based pagination strategy (add link)
#
# ## URL format
#
# Regardless of the pagination strategy, the expected format is:
# ```kit-url
#  GET https://my.api/my-resource?page[(resource_path.)pagination_keyword]=cursor_data
# ```
# When the `resource_path` is omitted, pagination applies to the top level resource.
# With the cursor based strategy, `pagination_keyword` could be any of `[:size, :after, :before]`.
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
# ## On nested pagination
#
# `Kit::Api::Json` supports pagination on:
# - the top level resource when it a collection
# - any to-many relationships as long as **every** ancestor is singular (either a singular resource or a to-one relationship).
#
# Pagination data is provider per path, like: `page[author.books.next]`
#
# So it only has meaning when that path maps to a **single** collection.
#
# Here are a few examples:
# ```kit-url
#  # VALID: the top level resource is singular (author A.id=a1), so pagination data can apply
#  #  to `books`, because there can only be one books collection.
#  GET https://my.api/authors/a1?page[books.next]=cursor_data
#
#  # VALID: the top level resource is singular (book B.id=b1), it's author relationship is
#  #  singular (to-one relationship), so pagination can apply to `author.books`.
#  #  Again, there is only be one books collection.
#  GET https://my.api/books/1?page[author.books.next]=cursor_data
#
#  # INVALID: the top level resource is a collection (authors), so pagination data CAN NOT
#  #  apply to `books`, because there are multiple books collections (one for author A.id=a1,
#  #  one for author A.id=a2, etc). Except for luck, that pagination data is meaningless.
#  GET https://my.api/authors?page[books.next]=cursor_data
# ```
#
# As a result, an error is returned when trying to paginate on nested collections.
#
# ## Considerations for different strategies
# *Todo: move this somewhere else*
#
# Pagination strategies have different implications for data Resolvers.
#
# ### Cursor based strategy
#
# A `cursor` is what we call pagination data when it allows to identify precisely at least one boundary of a subset.
#
# For the following pagination data `page[size]=10&page[next]=gt|Author.id=1000`, steps will happen in a specific order:
#  1. Add a boundary condition with the cursor data, `Author.id > 1000`
#  2. Apply filters & sorting
#  3. Apply page size limit
#
# **The boundary condition takes precedence on the filtering, sorting & page size limit.**
#
# ### Offset based strategy
#
# For the following pagination data `page[size]=10&page[offset]=2`, steps will happen in a specific order:
#  1. Apply filters & sorting
#  2. Add an offset of `offset_value * page_size`
#  2. Apply page size limit
#
# **The filters & sorting take precedence on the offset condition.**
#
# ## References
# - https://jsonapi.org/format/1.1/#fetching-pagination
# - https://jsonapi.org/profiles/ethanresnick/cursor-pagination/
#
module Kit::Api::JsonApi::Services::Request::Pagination

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  # Entry point. Parse & validate pagination data before adding it to the `Request`.
  def self.handle_pagination(query_params:, request:)
    args = { config: config, query_params: query_params, request: request }

    Kit::Organizer.call({
      list: [
        self.method(:parse),
        self.method(:validate),
        self.method(:add_to_request),
      ],
      ctx:  args,
    })
  end

  # @see https://jsonapi.org/format/1.1/#fetching-pagination
  # @see https://jsonapi.org/profiles/ethanresnick/cursor-pagination/
  def self.parse(query_params:)
    data = query_params[:page] || {}
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

    [:ok, parsed_query_params_page: list]
  end

  def self.validate(parsed_query_params_page:)
    errors = []

    parsed_query_params_page.each do |path, list|
      if path == :top_level
        resource = request[:top_level_resource]
      else
        resource = request[:related_resources][path]
      end

      if !resource
        errors << { detail: "Page: `#{ path }` is not an included relationship" }
      end

      list.each do |_attr_name, values|
        if values.size > 1
          error_path = (path == :top_level) ? name.to_s : "#{ path }.#{ name }"
          errors << { detail: "Page: `#{ error_path }` has multiple values" }
        end
      end
    end

    if errors.size > 0
      [:error, errors: errors]
    else
      [:ok]
    end
  end

  def self.add_to_request(config:, parsed_query_params_page:, request:)
    request[:pagination] = parsed_query_params_page

    [:ok, request: request]
  end

end
