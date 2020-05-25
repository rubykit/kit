module Kit::Api::JsonApi::Services::Resolvers::Paginators::Cursor

  def self.to_h
    {
      import:    self.method(:pagination_import),
      condition: self.method(:pagination_condition),
      export:    self.method(:pagination_export),
    }
  end

  # Add validation on Request creation.
  def self.pagination_import
  end

  # Add condition on QueryNode.
  def self.pagination_condition(request:, query_node:)
    #cursor_data = request[query_node[:path]]

    #if request[:pagination][query_node[:path]]
    #end
    nil
  end

  # Generate query_params from collection
  def self.pagination_export(query_node:, records:)
    {
      current: { page: { before: 'v', after: 'w' } },
      prev:    { page: { before: 'x' } },
      next:    { page: { after: 'y' } },
    }
  end

end
