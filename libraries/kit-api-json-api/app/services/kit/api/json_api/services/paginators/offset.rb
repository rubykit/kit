# ## Offset based pagination strategy
#
# For the following pagination data `page[size]=10&page[offset]=2`, steps will happen in a specific order:
#  1. Apply filters & sorting
#  2. Add an offset of `offset_value * page_size`
#  2. Apply page size limit
#
# **The filters & sorting take precedence on the offset condition.**
module Kit::Api::JsonApi::Services::Paginators::Offset

  def self.paginator_type
    :kit_api_paginator_offset
  end

  def self.to_h
    {
      type:      paginator_type,
      import:    self.method(:pagination_import),
      condition: self.method(:pagination_condition),
      export:    self.method(:pagination_export),
    }
  end

  # Add validation on Request creation.
  def self.pagination_import
    [:ok]
  end

  # Add condition on QueryNode.
  def self.pagination_condition(request:, query_node:)
    [:ok]
  end

  # Generate query_params from collection
  def self.pagination_export(query_node:, records:)
    {
      current: { page: { offset: '2' } },
      prev:    { page: { offset: '1' } },
      next:    { page: { offset: '3' } },
    }
  end

end
