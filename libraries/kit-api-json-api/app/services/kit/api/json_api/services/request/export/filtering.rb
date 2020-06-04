# Logic to generate `filter` query_params for links
module Kit::Api::JsonApi::Services::Request::Export::Filtering

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_filtering(request:, included_paths:, query_params:)
    return [:ok] if !request[:config][:linker_config][:export_filters]

    paths_list = included_paths[:list]
    path_name  = included_paths[:path]

    qp = {}

    (request[:filters] || {}).each do |filters_path, filters|
      next if !paths_list.include?(filter_path)

      filters_path = filters_path[(path_name.size + 1)..]
      filters.map do |name:, op:, value:|
        filter_path = "#{ filters_path }#{ filters_path.size > 0 ? '.' : '' }#{ name }"

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
