require_relative '../../rails_helper'

describe 'Json:Api Index requests', type: :request do
  include_context 'json:api'
  include_context 'config dummy app'

  let(:subject) { get path, headers: jsonapi_headers }

  before { subject }

  let(:ar_models) do
    {
      author:     Kit::JsonApiSpec::Models::Write::Author,
      book:       Kit::JsonApiSpec::Models::Write::Book,
      book_store: Kit::JsonApiSpec::Models::Write::BookStore,
      chapter:    Kit::JsonApiSpec::Models::Write::Chapter,
      photo:      Kit::JsonApiSpec::Models::Write::Photo,
      serie:      Kit::JsonApiSpec::Models::Write::Serie,
      store:      Kit::JsonApiSpec::Models::Write::Store,
    }
  end

  shared_examples 'returns valid JSON:API data' do
    let(:path) { Kit::Router::Services::Adapters::Http::Mountpoints.path(id: "specs|api|#{ resource_name }|index") }

    let(:expected_count) do
      [ar_models[resource_name].count, KIT_DUMMY_APP_API_CONFIG[:page_size]].select(&:positive?).min
    end

    it 'returns the expected number of top-level objects' do
      expect(response.status).to eq 200
      expect(expected_count).to be > 0
      expect(jsonapi_response_body[:data].size).to eq expected_count
      expect(jsonapi_response_body[:data].map { |el| el[:type] }.uniq).to eq [resource_name.to_s]
    end
  end

  KIT_DUMMY_APP_API_CONFIG[:resources].each do |_, resource|
    tmp_resource_name = resource[:name]

    context "for #{ tmp_resource_name } resources" do
      let(:resource_name) { tmp_resource_name }

      it_behaves_like 'returns valid JSON:API data'
    end
  end

end
