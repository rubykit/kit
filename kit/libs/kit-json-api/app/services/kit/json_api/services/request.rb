# Transform query_params data to an actionable Request
module Kit::JsonApi::Services::Request

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  def self.create_request(query_params:)
    request = {}

    Kit::Organizer.call({
      list: [
        Kit::JsonApi::Services::Request::RelatedResources.method(:handle_related_resources),
        Kit::JsonApi::Services::Request::SparseFieldsets.method(:handle_sparse_fieldsets),
        Kit::JsonApi::Services::Request::Sorting.method(:handle_sorting),
        Kit::JsonApi::Services::Request::Filering.method(:handle_filtering),
        Kit::JsonApi::Services::Request::Pagination.method(:handle_pagination),
      ],
      ctx:  { query_params: query_params, request: request },
    })
  end

end
