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

  # Add condition on QueryNode.
  def self.pagination_condition(query_node:)
    request         = query_node[:request]
    pagination_data = request.dig(:pagination, query_node[:path])

    return nil if !pagination_data

    after_cursor    = pagination_data[:after]
    before_cursor   = pagination_data[:before]
    ordering        = query_node[:sorting]

    if after_cursor && after_cursor.size > 0
      after_condition = Kit::Pagination::Condition.condition_for_after(ordering: ordering, cursor_data: after_cursor)[1][:condition]
    end

    if before_cursor && before_cursor.size > 0
      before_condition = Kit::Pagination::Condition.condition_for_before(ordering: ordering, cursor_data: before_cursor)[1][:condition]
    end

    if after_condition && before_condition
      { op: :and, values: [after_condition, before_condition] }
    elsif after_condition
      after_condition
    elsif before_condition
      before_condition
    else
      nil
    end
  end

  # Generate query_params from collection
  def self.pagination_export(query_node:, records:)
    return { current: {}, prev: {}, next: {} } if records.size == 0

    config         = query_node[:request][:config]
    ordering       = query_node[:sorting]
    enc_key        = config[:meta][:kit_api_paginator_cursor][:encrypt_secret]

    fe_data        = records.first[:raw_data].attributes.symbolize_keys
    le_data        = records.last[:raw_data].attributes.symbolize_keys

    fe_cursor_data_included = Kit::Pagination::Cursor.cursor_data_for_element(ordering: ordering, element: fe_data, included: true)[1][:cursor_data]
    fe_cursor_data_excluded = Kit::Pagination::Cursor.cursor_data_for_element(ordering: ordering, element: fe_data)[1][:cursor_data]
    le_cursor_data_included = Kit::Pagination::Cursor.cursor_data_for_element(ordering: ordering, element: le_data, included: true)[1][:cursor_data]
    le_cursor_data_excluded = Kit::Pagination::Cursor.cursor_data_for_element(ordering: ordering, element: le_data)[1][:cursor_data]

    fe_cursor_included = Kit::Api::Services::Encryption.encrypt(data: fe_cursor_data_included, key: enc_key)[1][:encrypted_data]
    fe_cursor_excluded = Kit::Api::Services::Encryption.encrypt(data: fe_cursor_data_excluded, key: enc_key)[1][:encrypted_data]
    le_cursor_included = Kit::Api::Services::Encryption.encrypt(data: le_cursor_data_included, key: enc_key)[1][:encrypted_data]
    le_cursor_excluded = Kit::Api::Services::Encryption.encrypt(data: le_cursor_data_excluded, key: enc_key)[1][:encrypted_data]

    {
      current: { page: { after:  fe_cursor_included, before: le_cursor_included } },
      prev:    { page: { before: fe_cursor_excluded } },
      next:    { page: { after:  le_cursor_excluded } },
    }
  end

end
