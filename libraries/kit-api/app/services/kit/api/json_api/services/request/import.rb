# Namespace for Request generation from query_params
module Kit::Api::JsonApi::Services::Request::Import

  # Takes hydrated query params to create a Request.
  # @see Kit::Api::JsonApi::Contracts#Request
  def self.import(query_params:, api_request: nil)
    api_request ||= {}

    Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Request::Import::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets.method(:handle_sparse_fieldsets),
        Kit::Api::JsonApi::Services::Request::Import::Sorting.method(:handle_sorting),
        Kit::Api::JsonApi::Services::Request::Import::Filtering.method(:handle_filtering),
        Kit::Api::JsonApi::Services::Request::Import::Pagination.method(:handle_pagination),
      ],
      ctx:  { query_params: query_params, api_request: api_request },
    })
  end

end
