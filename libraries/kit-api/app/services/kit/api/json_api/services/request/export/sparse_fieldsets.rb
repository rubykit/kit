# Logic to generate `fields` query_params for links
module Kit::Api::JsonApi::Services::Request::Export::SparseFieldsets

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_sparse_fieldsets(api_request:, included_paths:, query_params:)
    return [:ok] if !api_request[:config][:linker_config][:export_sparse_fieldsets]

    paths_list = included_paths[:list]
    path_name  = included_paths[:path]

    # Expected resource types given `include`
    included_resources = paths_list.values.map { |el| el[:name] }

    qp = (api_request[:fields] || {})
      .select do |resource_name, _fields|
        included_resources.include?(resource_name) || (path_name == '' && api_request[:top_level_resource][:name] == resource_name)
      end
      .map { |resource_name, fields| [resource_name.to_s, fields.join(',')] }
      .to_h

    if qp.size > 0
      query_params[:fields] = qp
    end

    [:ok, query_params: query_params]
  end

end
