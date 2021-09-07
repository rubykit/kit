RSpec.shared_context 'url' do

  let(:request_path) { "#{ route_path }?#{ query_params_str }" }

  let(:route_params) { {} }
  let(:route_path)   { Kit::Router::Adapters::Http::Mountpoints.path(id: route_id, params: route_params) }

  let(:query_params) { {} }
  let(:query_params_str) do
    _, ctx = Kit::Api::JsonApi::Services::Url.serialize_query_params(query_params: query_params || {})
    ctx[:query_params_str]
  end

end
