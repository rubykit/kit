# Logic to generate `fields` query_params for links
module Kit::Api::JsonApi::Services::Request::Export::SparseFieldsets

  include Kit::Contract::Mixin
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  def self.handle_sparse_fieldsets(request:, included_paths:, query_params:)
    return [:ok] if !request[:config][:linker_config][:export_sparse_fieldsets]

    qp = (request[:fields] || {})
      .map { |resource_name, fields| [resource_name, fields.join(',')] }
      .to_h

    if qp.size > 0
      query_params[:fields] = qp
    end

    [:ok, query_params: query_params]
  end

end
