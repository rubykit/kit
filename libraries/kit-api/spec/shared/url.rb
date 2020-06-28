RSpec.shared_context 'url' do

  let(:router_path)      { Kit::Router::Services::Adapters::Http::Mountpoints.path(id: path_id) }
  let(:query_params_str) { Kit::Api::JsonApi::Services::Url.serialize_query_params(query_params: query_params || {})[1][:query_params_str] }
  let(:request_path)     { "#{ router_path }?#{ query_params_str }" }

end
