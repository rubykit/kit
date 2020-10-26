require_relative '../../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Import::RelatedResources do
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

  context 'with related resources' do

    subject do
      service.handle_related_resources(
        query_params: query_params,
        api_request:  api_request,
      )
    end

    context 'with valid types && valid fields' do
      let(:url) { 'https://domain.com/author?include=books.author.books,series.books' }

      it 'add the expected data to the request' do
        status, ctx = subject
        expect(status).to eq :ok
        expect(ctx[:api_request][:related_resources].keys).to eq [
          'books',
          'books.author',
          'books.author.books',
          'series',
          'series.books',
        ]
      end
    end

    context 'with an invalid relationship' do
      let(:url) { 'https://domain.com/author?include=books.author.cars' }

      it 'generates the proper errors' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Related resource: `books.author.cars` is not a valid relationship'
      end
    end

  end

end
