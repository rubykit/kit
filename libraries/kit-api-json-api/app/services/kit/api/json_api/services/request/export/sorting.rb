# Logic to generate `sort` query_params for links
module Kit::Api::JsonApi::Services::Request::Export::Sorting

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_sorting(request:, included_paths:, query_params:)
    return [:ok] if !request[:config][:linker_config][:export_sorting]

    paths_list = included_paths[:list]
    path_name  = included_paths[:path]

    qp = (request[:sorting] || {})
      .filter_map do |sort_path, ordering|
        if sort_path == :top_level
          next if path_name != ''

          sort_path = ''
        else
          next if !paths_list.include?(sort_path)

          # Account for . if there is further nesting. Otherwise defaults to ''.
          sort_path = sort_path[((path_name.size > 0) ? (path_name.size + 1) : 0)..] || ''
        end

        ordering.map do |sort_name:, direction:|
          "#{ direction == :asc ? '' : '-' }#{ sort_path }#{ sort_path.size > 0 ? '.' : '' }#{ sort_name }"
        end
      end
      .flatten
      .join(',')

    if qp.size > 0
      query_params[:sort] = qp
    end

    [:ok, query_params: query_params]
  end

end
