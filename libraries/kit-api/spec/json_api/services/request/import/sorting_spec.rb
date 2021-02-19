require_relative '../../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Import::Sorting do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config)   { config_dummy_app }

  let(:query_params) { Kit::Api::JsonApi::Services::Url.parse_query_params(url: url)[1][:query_params] }
  let(:api_request) do
    {
      config:             config,
      top_level_resource: Kit::JsonApiSpec::Resources::Author.to_h,
    }
  end

  context 'with sort order' do

    subject do
      params = {
        query_params: query_params,
        api_request:  api_request,
      }
      Kit::Api::JsonApi::Services::Request::Import::RelatedResources.handle_related_resources(**params)
      service.handle_sorting(**params)
    end

    context 'with valid include && valid sort criteria' do
      let(:url) { 'https://domain.com/author?include=books&sort=-name,books.date_published,date_of_birth,-books.title' }

      it 'add the expected data to the request' do
        status, ctx = subject
        expect(status).to eq :ok
        expect(ctx[:api_request][:related_resources].keys).to eq ['books']
        expect(ctx[:api_request][:sorting]).to eq({
          :top_level => [{ direction: :desc, sort_name: :name           }, { direction: :asc,  sort_name: :date_of_birth }],
          'books'    => [{ direction: :asc,  sort_name: :date_published }, { direction: :desc, sort_name: :title }],
        })
      end
    end

    context 'with invalid include && valid sort criteria' do
      let(:url) { 'https://domain.com/author?include=series&sort=books.date_published' }

      it 'generates the proper errors' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Sort: `books` is not an included relationship'
      end
    end

    context 'with valid include && invalid sort criteria' do
      let(:url) { 'https://domain.com/author?include=books&sort=books.random' }

      it 'generates the proper errors' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Sort: `books.random` is not a valid sorting criteria'
      end
    end

  end

end
