require_relative '../../rails_helper'

describe 'Json:Api query_params requests', type: :request do
  include_context 'config dummy app'
  include_context 'json:api'
  include_context 'url'

  let(:subject)       { get request_path, headers: jsonapi_headers }
  let(:route_id)      { "specs|api|#{ resource_name }|index" }
  let(:resource_name) { :author }

  before { subject }

  context 'with page[size]' do
    let(:query_params) do
      {
        page: { size: 1 },
      }
    end

    it 'returns the correct number of resources objects' do
      expect(jsonapi_response_body[:data].size).to eq 1
    end
  end

  context 'with empty include=' do
    let(:query_params) do
      {
        include: '',
      }
    end

    it 'returns the correct number of resources objects' do
      expect(jsonapi_response_body[:included].size).to eq 0
    end
  end

end
