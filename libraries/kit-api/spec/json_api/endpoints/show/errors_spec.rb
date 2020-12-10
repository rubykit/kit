require_relative '../../../rails_helper'

describe 'Json:Api SHOW requests - ERRORS', type: :request do
  include_context 'config dummy app'
  include_context 'json:api'
  include_context 'url'

  let(:subject)  { get request_path, headers: jsonapi_headers }

  let(:route_id) { "specs|api|#{ resource_name }|show" }

  let(:query_params) do
    { include: '' }
  end

  let(:resource)       { KIT_DUMMY_APP_API_CONFIG[:resources][:author] }
  let(:resource_name)  { resource[:name] }
  let(:resource_model) { config_dummy_app_ar_models[resource_name] }

  context 'for a non existing resource' do
    let(:resource_id)   { resource_model.maximum(:id).next }

    let(:route_params) do
      { resource_id: resource_id }
    end

    before { subject }

    it 'returns the expected response' do
      expect(response.status).to eq 404

      errors = jsonapi_response_body[:errors]

      expect(errors).to be_a Array
      expect(errors.size).to eq 1

      error = errors[0]

      expect(error[:detail]).to eq 'Could not find resource.'
      expect(error[:status]).to eq '404'
    end

    #it_behaves_like 'a valid json:api response'
  end

end
