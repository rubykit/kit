# Logic to generate `sort` query_params for links
module Kit::Api::JsonApi::Services::Request::Export::Sorting

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_sorting(api_request:, included_paths:, query_params:)
    return [:ok] if !api_request[:config][:linker_config][:export_sorting]

    qp = []

    (api_request[:sorting] || {}).each do |sort_path, ordering|
      adjusted_path = Kit::Api::JsonApi::Services::Request::Export
        .adjusted_path(included_paths: included_paths, current_path: sort_path)[1][:adjusted_path]
      next if !adjusted_path

      #ordering.each do |sort_name:, direction:|
      ordering.each do |el|
        sort_name = el[:sort_name]
        direction = el[:direction]

        sort_qp_str = "#{ direction == :asc ? '' : '-' }#{ adjusted_path }#{ adjusted_path.size > 0 ? '.' : '' }#{ sort_name }"
        qp << sort_qp_str
      end
    end

    if qp.size > 0
      query_params[:sort] = qp.join(',')
    end

    [:ok, query_params: query_params]
  end

end
