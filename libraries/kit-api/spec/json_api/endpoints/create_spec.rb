require_relative '../../rails_helper'

describe 'Json:Api Show requests', type: :request do
  include_context 'config dummy app'
  include_context 'json:api'
  include_context 'url'

  let(:subject) { post request_path, headers: jsonapi_headers, params: body }

  shared_examples 'returns valid JSON:API data' do
    let(:route_id) { "specs|api|#{ resource_name }|create" }

    let(:query_params) do
      { include: '' }
    end

    let(:attributes) { FactoryBot.build(resource_name).slice(resource[:writeable_attributes].keys) }
    let(:attributes_serialized) { Oj.safe_load(Oj.dump(attributes, mode: :json)) }

    let(:body) do
      Oj.dump({
        data: {
          attributes: attributes,
          type:       resource_name,
        },
      }, mode: :json,)
    end

    before { subject }

    it 'creates the objects' do
      expect(response.status).to eq 201

      data = jsonapi_response_body[:data]

      expect(data).to be_a Hash
      expect(data[:type]).to eq resource_name.to_s

      attributes.each do |k, _v|
        expect(data[:attributes][k.to_sym]).to eq attributes_serialized[k]
      end
    end

    it_behaves_like 'a valid json:api response'
  end

  KIT_DUMMY_APP_API_CONFIG[:resources].each do |_, resource|
    tmp_resource_name = resource[:name]

    context "for #{ tmp_resource_name } resources" do
      let(:resource_name) { tmp_resource_name }
      let(:resource)      { config_dummy_app[:resources][resource_name] }

      it_behaves_like 'returns valid JSON:API data'
    end
  end

end
