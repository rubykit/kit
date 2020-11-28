require_relative '../../rails_helper'

describe 'Json:Api Show requests', type: :request do
  include_context 'config dummy app'
  include_context 'json:api'
  include_context 'url'

  let(:subject) { delete request_path, headers: jsonapi_headers }

  shared_examples 'returns valid JSON:API data' do
    let(:route_id) { "specs|api|#{ resource_name }|delete" }
    let(:route_params) do
      { resource_id: model_instance.id }
    end

    let(:model_instance) { FactoryBot.create(resource_name) }
    let(:model_class)    { model_instance.class }

    it 'deletes the objects' do
      expect(model_instance.persisted?).to be true
      expect(model_class.find_by(id: model_instance.id)).not_to be nil

      subject

      expect(response.status).to eq 204
      expect(model_class.find_by(id: model_instance.id)).to be nil
    end
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
