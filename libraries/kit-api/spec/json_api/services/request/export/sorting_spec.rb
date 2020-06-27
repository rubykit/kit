require_relative '../../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Export::Sorting do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config)   { config_dummy_app }

  let(:api_request) do
    {
      config:             config,
      top_level_resource: Kit::JsonApiSpec::Resources::Author.to_h,
    }
  end

  let(:url) { "https://domain.com/author?#{ query_params_str }" }

  let(:query_params_str_out) do
    qp = ctx[:query_params].select { |k, _v| k == :sort }
    Kit::Api::JsonApi::Services::Url.serialize_query_params(query_params: qp)[1][:query_params_str]
  end

  subject do
    Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Url.method(:parse_query_params),
        Kit::Api::JsonApi::Services::Request::Import::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Import::Sorting.method(:handle_sorting),
        -> { [:ok, query_params: {}] },
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:included_paths),
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Export::Sorting.method(:handle_sorting),
      ],
      ctx:  { api_request: api_request, url: url, path: path },
    })
  end

  let(:status) { subject[0] }
  let(:ctx)    { subject[1] }

  describe '.handle_sorting' do
    let(:query_params_str) { 'include=books&sort=-name,books.date_published,date_of_birth,-books.title' }

    context 'existing filters for top level' do
      let(:path) { '' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:sort]).to eq '-name,date_of_birth,books.date_published,-books.title'

        expect(query_params_str_out).to eq 'sort=-name%2Cdate_of_birth%2Cbooks.date_published%2C-books.title'
      end
    end

    context 'existing filters for nested level' do
      let(:path) { 'books' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:sort]).to eq 'date_published,-title'

        expect(query_params_str_out).to eq 'sort=date_published%2C-title'
      end
    end

    context 'no filters for nested level' do
      let(:path) { 'series' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:sort]).to be nil
      end
    end

  end

end
