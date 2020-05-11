require_relative '../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::SparseFieldsets do
  let(:service)  { described_class }

  let(:config) do
    Kit::Api::JsonApi::Types::Config[
      resources: {
        books:   Kit::JsonApiSpec::Resources::Book.resource,
        authors: Kit::JsonApiSpec::Resources::Author.resource,
      },
    ]
  end

  let(:query_params) { Kit::Api::JsonApi::Services::Url::Parser.parse_url(url: url)[1][:query_params] }
  let(:request)      { Kit::Api::JsonApi::Types::Request[] }

  context 'with sparse fieldsets' do

    subject do
      service.handle_sparse_fieldsets(
        config:       config,
        query_params: query_params,
        request:      request,
      )
    end

    context 'with valid types && valid fields' do
      let(:url) { 'https://domain.com/author?fields[authors]=name,date_of_birth&fields[books]=title'}

      it 'add the expected data to the request' do
        status, ctx = subject
        expect(status).to eq :ok
        expect(ctx[:request][:fields]).to eq({ authors: [:name, :date_of_birth,], books: [:title,], })
      end
    end

    context 'with an invalid type && an invalid field' do
      let(:url) { 'https://domain.com/author?fields[cars]=names&fields[books]=cars'}

      it 'generates the proper errors' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq "Sparse fieldsets: `cars` is not an available type"
        expect(ctx[:errors][1][:detail]).to eq "Sparse fieldsets: `books`.`cars` is not an available field"
      end
    end

  end

end