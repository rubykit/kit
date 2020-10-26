# Logic to generate `filter` query_params for links
module Kit::Api::JsonApi::Services::Request::Export::Filtering

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_filtering(api_request:, included_paths:, query_params:)
    return [:ok] if !api_request[:config][:linker_config][:export_filters]

    qp = {}

    (api_request[:filters] || {}).each do |filters_path, filters|
      adjusted_path = Kit::Api::JsonApi::Services::Request::Export
        .adjusted_path(included_paths: included_paths, current_path: filters_path)[1][:adjusted_path]
      next if !adjusted_path

      filters.map do |name:, op:, value:|
        # Add filter name
        filter_path = "#{ adjusted_path }#{ adjusted_path.size > 0 ? '.' : '' }#{ name }"

        qp[filter_path] ||= {}
        qp[filter_path][op] = value.join(',')
      end
    end

    if qp.size > 0
      query_params[:filter] = qp
    end

    [:ok, query_params: query_params]
  end

end
