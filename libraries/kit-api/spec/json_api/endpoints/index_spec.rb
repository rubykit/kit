require_relative '../../rails_helper'

describe 'Json:Api INDEX requests', type: :request do
  include_context 'config dummy app'
  include_context 'json:api'
  include_context 'url'

  let(:subject) { get request_path, headers: jsonapi_headers }

  before { subject }

  shared_examples 'returns valid JSON:API data' do
    let(:route_id) { "specs|api|#{ resource_name }|index" }
    let(:query_params) do
      { include: '' }
    end

    let(:expected_count) do
      [config_dummy_app_ar_models[resource_name].count, KIT_DUMMY_APP_API_CONFIG[:page_size]].select(&:positive?).min
    end

    it 'returns the expected number of top-level objects' do
      expect(expected_count).to be > 0

      expect(response.status).to eq 200

      data = jsonapi_response_body[:data]

      expect(data).to be_a Array
      expect(data.size).to eq expected_count
      expect(data.map { |el| el[:type] }.uniq).to eq [resource_name.to_s]
    end

    it_behaves_like 'a valid json:api response'
  end

  KIT_DUMMY_APP_API_CONFIG[:resources].each do |_, resource|
    tmp_resource_name = resource[:name]

    context "for #{ tmp_resource_name } resources" do
      let(:resource_name) { tmp_resource_name }

      it_behaves_like 'returns valid JSON:API data'
    end
  end

end
