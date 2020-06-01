# Transform hydrated query_params data to an actionable Request.
module Kit::Api::JsonApi::Services::Request

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  # Takes hydrated query params to create a Request.
  # @see Kit::Api::JsonApi::Contracts#Request
  def self.create_request(query_params:)
    request = {}

    Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Request::Import::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets.method(:handle_sparse_fieldsets),
        Kit::Api::JsonApi::Services::Request::Import::Sorting.method(:handle_sorting),
        Kit::Api::JsonApi::Services::Request::Import::Filering.method(:handle_filtering),
        Kit::Api::JsonApi::Services::Request::Import::Pagination.method(:handle_pagination),
      ],
      ctx:  { query_params: query_params, request: request },
    })
  end

  def self.create_query_params(request:, path:)
    # Add sparse fieldset
    # Add filter
    # Add sort
    # Add related resource
    { qp: 1 }
  end

  def self.add_sparse_fieldset
  end

  def self.add_filters(request:, path:)
    request
  end

end
