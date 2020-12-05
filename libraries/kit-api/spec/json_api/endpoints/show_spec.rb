require_relative '../../rails_helper'

describe 'Json:Api SHOW requests', type: :request do
  include_context 'config dummy app'
  include_context 'json:api'
  include_context 'url'

  let(:subject) { get request_path, headers: jsonapi_headers }

  let(:route_id) { "specs|api|#{ resource_name }|show" }

  let(:query_params) do
    { include: '' }
  end

  shared_examples 'returns valid JSON:API data' do
    before { subject }

    it 'returns the expected number of top-level objects' do
      expect(response.status).to eq 200

      data = jsonapi_response_body[:data]

      expect(data).to be_a Hash
      expect(data[:type]).to eq resource_name.to_s
      expect(data[:id]).to   eq resource_id.to_s
    end

    #it_behaves_like 'a valid json:api response'
  end

  resources = KIT_DUMMY_APP_API_CONFIG[:resources]

  resources.each do |_, resource|
    tmp_resource_name = resource[:name]

    context "for #{ tmp_resource_name } resources" do
      let(:resource_name)  { tmp_resource_name }
      let(:resource_model) { config_dummy_app_ar_models[resource_name] }
      let(:resource_id)    { resource_model.maximum(:id) }

      let(:route_params) do
        { resource_id: resource_id }
      end

      it_behaves_like 'returns valid JSON:API data'
    end
  end

end
