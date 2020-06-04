# Namespace for Request query_params generation.
module Kit::Api::JsonApi::Services::Request::Export

  def self.export(request:, path:)
    status, ctx = Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:included_paths),
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Export::SparseFieldsets.method(:handle_sparse_fieldsets),
        Kit::Api::JsonApi::Services::Request::Export::Sorting.method(:handle_sorting),
        Kit::Api::JsonApi::Services::Request::Export::Filtering.method(:handle_filtering),
        #Kit::Api::JsonApi::Services::Request::Export::Pagination.method(:handle_pagination),
      ],
      ctx:  {
        request:      request,
        path:         path,
        query_params: {},
      },
    })

    [status, ctx.slice(:errors, :query_params)]
  end

end
