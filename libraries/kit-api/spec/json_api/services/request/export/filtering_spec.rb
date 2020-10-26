require_relative '../../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Export::Filtering do
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
    qp = ctx[:query_params].select { |k, _v| k == :filter }
    Kit::Api::JsonApi::Services::Url.serialize_query_params(query_params: qp)[1][:query_params_str]
  end

  subject do
    Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Url.method(:parse_query_params),
        Kit::Api::JsonApi::Services::Request::Import::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Import::Filtering.method(:handle_filtering),
        -> { [:ok, query_params: {}] },
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:included_paths),
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Export::Filtering.method(:handle_filtering),
      ],
      ctx:  { api_request: api_request, url: url, path: path },
    })
  end

  let(:status) { subject[0] }
  let(:ctx)    { subject[1] }

  describe '.handle_filtering' do
    let(:query_params_str) { 'include=books&filter[name]=Tolkien,Rowling&filter[books.date_published][lt]=2002&filter[date_of_birth][gt]=1950&filter[books.title]=Title' }

    context 'existing filters for top level' do
      let(:path) { '' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:filter]).to eq({
          'name'                 => { in: 'Tolkien,Rowling' },
          'books.date_published' => { lt: '2002' },
          'date_of_birth'        => { gt: '1950' },
          'books.title'          => { eq: 'Title' },
        })

        expect(query_params_str_out).to eq 'filter[name][in]=Tolkien%2CRowling&filter[date_of_birth][gt]=1950&filter[books.date_published][lt]=2002&filter[books.title][eq]=Title'
      end
    end

    context 'existing filters for nested level' do
      let(:path) { 'books' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:filter]).to eq({
          'date_published' => { lt: '2002' },
          'title'          => { eq: 'Title' },
        })

        expect(query_params_str_out).to eq 'filter[date_published][lt]=2002&filter[title][eq]=Title'
      end
    end

    context 'no filters for nested level' do
      let(:path) { 'series' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:filter]).to be nil
      end
    end

  end

end
