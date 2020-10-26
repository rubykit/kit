# Namespace for Request query_params generation.
module Kit::Api::JsonApi::Services::Request::Export

  def self.export(api_request:, path:)
    status, ctx = Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:included_paths),
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Export::SparseFieldsets.method(:handle_sparse_fieldsets),
        Kit::Api::JsonApi::Services::Request::Export::Sorting.method(:handle_sorting),
        Kit::Api::JsonApi::Services::Request::Export::Filtering.method(:handle_filtering),
        Kit::Api::JsonApi::Services::Request::Export::Pagination.method(:handle_page_size),
      ],
      ctx:  {
        api_request:  api_request,
        path:         path,
        query_params: {},
      },
    })

    [status, ctx.slice(:errors, :query_params)]
  end

  # Helper method to check if `current_path` is part of `included_paths[:list]` and adjust it given `included_paths[:path]`
  def self.adjusted_path(included_paths:, current_path:)
    paths_list = included_paths[:list]
    path_name  = included_paths[:path]

    if current_path == :top_level
      adjusted_path = (path_name != '') ? nil : ''
    elsif !paths_list.include?(current_path)
      adjusted_path = nil
    else
      # Account for . if there is further nesting. Otherwise defaults to ''.
      adjusted_path = current_path[((path_name.size > 0) ? (path_name.size + 1) : 0)..] || ''
    end

    [:ok, adjusted_path: adjusted_path]
  end

end
