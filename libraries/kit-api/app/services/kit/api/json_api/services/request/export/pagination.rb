# Logic to generate `page[size]` query_params for links
module Kit::Api::JsonApi::Services::Request::Export::Pagination

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  # Add `page[size]` to query params
  def self.handle_page_size(api_request:, included_paths:, query_params:)
    qp = {}

    (api_request[:pagination] || {}).each do |page_path, data|
      next if !data[:size]

      adjusted_path = Kit::Api::JsonApi::Services::Request::Export
        .adjusted_path(included_paths: included_paths, current_path: page_path)[1][:adjusted_path]
      next if !adjusted_path

      adjusted_path = "#{ adjusted_path }#{ adjusted_path.size > 0 ? '.' : '' }size"

      qp[adjusted_path] = data[:size]
    end

    if qp.size > 0
      query_params[:page] = qp
    end

    [:ok, query_params: query_params]
  end

end
