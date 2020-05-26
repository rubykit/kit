# ## Cursor based pagination strategy
#
# A `cursor` is what we call pagination data when it allows to identify precisely at least one boundary of a subset.
#
# ## URL format
#
# The expected format is:
# ```kit-url
#  GET https://my.api/my-resource?page[(resource_path.)pagination_keyword]=cursor_data
# ```
# When the `resource_path` is omitted, pagination applies to the top level resource.
#
# With this strategy, `pagination_keyword` could be any of `[:size, :after, :before]`.
#
# ## Operations order
#
# For the following pagination data `page[size]=10&page[next]=gt|Author.id=1000`, steps will happen in a specific order:
#  1. Add a boundary condition with the cursor data, `Author.id > 1000`
#  2. Apply filters & sorting
#  3. Apply page size limit
#
# **The boundary condition takes precedence on the filtering, sorting & page size limit.**
#
# ## Nested pagination
#
# This paginator enables pagination on:
# - the top level resource when it a collection
# - any to-many relationships as long as **every** ancestor is singular (either a singular resource or a to-one relationship).
#
# Pagination data is provider per path, like: `page[author.books.next]`.
# So it only has meaning when that path identify a **single** collection.
# If there are different subsets, the data inside a cursor will only work with one the subset.
#
# As a result, an error is returned when trying to paginate on nested collections.
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
# ## References
# - https://jsonapi.org/profiles/ethanresnick/cursor-pagination/
#
module Kit::Api::JsonApi::Services::Paginators::Cursor

  def self.paginator_type
    :kit_api_paginator_cursor
  end

  def self.to_h
    {
      type:      paginator_type,
      import:    Kit::Api::JsonApi::Services::Paginators::Cursor::Validation.method(:validate),
      condition: self.method(:pagination_condition),
      export:    self.method(:pagination_export),
    }
  end

=begin
  # Add validation on Request creation.
  # TODO: rewrite this with a single Contract? Need to figure out how to generate the proper error messages.
  def self.pagination_import(request:, parsed_query_params_page:)
    config = request[:config]

    parsed_query_params_page.map do |path, list|
      path_prefix = path.size > 0 ? "#{ path }." : ''
      list.each do |key, value|
        # Only accepts :size, :after, :before keywords
        if ![:size, :after, :before].include?(key)
          return Kit::Error("Pagination error - Unsupported keyword `#{ key }` in `page[#{ path_prefix }#{ key }]`")
        end

        # Only accept single values
        if value.size > 1
          return Kit::Error("Paginator error - Multiple values for `page[#{ path_prefix }#{ key }]`")
        end
      end

      # :size needs to be a positive integer
      if list[:size]
        list[:size] = list[:size].to_i
        if list[:size] < 0
          return Kit::Error("Paginator error - Invalid value for `page[#{ path_prefix }size]`")
        end
      end

      # :after & :before need to be Strings, and to succesfully pass decryption
      [:after, :before].each do |key|
        value = list[key]
        if !value.is_a?(String)
          return Kit::Error("Paginator error - Invalid cursor value for `page[#{ path_prefix }#{ key }]`")
        end

        status, ctx = Kit::Api::JsonApi::Services::Crypt.decrypt_object(
          encrypted_data: value,
          key:            config[:meta][:kit_api_paginator_cursor][:encrypt_secret],
        )
        if status == :error
          return Kit::Error("Paginator error - Invalid cursor `page[#{ path_prefix }#{ key }]`")
        end

        list[key] = ctx[:data]
      end
    end

    # Detect nested pagination (pagination that targets a nested to_many).
    # This is probably never what API developers want because the a cursor only target one subset.
    # See `Nested pagination` in the module doc.
    #
    # Traverse every request path and count the collection nesting level. If > 1, not paginateable.
    parsed_query_params_page.map do |path, _list|
      level    = (request[:singular] == false) ? 1 : 0
      resource = request[:top_level_resource]

      path.split('.').each do |name|
        relationship = config[:resources][resource[:relationships][name]]
        level       += (relationship[:relationship_type] == :to_many) ? 1 : 0

        if level > 1 && (parsed_query_params_page[path][:before] || parsed_query_params_page[path][:after])
          return Kit::Error("Pagination error: can not use cursor pagination on path `#{ path }`")
        end

        resource = config[:resources][relationship[:resource]]
      end
    end

    [:ok, parsed_query_params_page: parsed_query_params_page]
  end
=end

  # Add condition on QueryNode.
  def self.pagination_condition(request:, query_node:)
    pagination_data = request[:pagination][query_node[:path]]
    after_cursor    = pagination_data[:after]
    before_cursor   = pagination_data[:before]
    size            = pagination_data[:size]

    # TODO: plug Kit::Pagination

    [:ok]
  end

  # Generate query_params from collection
  def self.pagination_export(query_node:, records:)
    # TODO: plug Kit::Pagination

    {
      current: { page: { before: 'v', after: 'w' } },
      prev:    { page: { before: 'x' } },
      next:    { page: { after: 'y' } },
    }
  end

end
