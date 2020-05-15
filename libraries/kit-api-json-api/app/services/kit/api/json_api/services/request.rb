# Transform hydrated query_params data to an actionable Request.
module Kit::Api::JsonApi::Services::Request

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  # Takes hydrated query params to create a Request.
  # @see Kit::Api::JsonApi::Contracts#Request
  def self.create_request(query_params:)
    request = {}

    Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Request::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::SparseFieldsets.method(:handle_sparse_fieldsets),
        Kit::Api::JsonApi::Services::Request::Sorting.method(:handle_sorting),
        Kit::Api::JsonApi::Services::Request::Filering.method(:handle_filtering),
        Kit::Api::JsonApi::Services::Request::Pagination.method(:handle_pagination),
      ],
      ctx:  { query_params: query_params, request: request },
    })
  end

end
