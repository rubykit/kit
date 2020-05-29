require_relative '../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config)   { config_dummy_app }

  let(:query_params) { Kit::Api::JsonApi::Services::Url.parse_query_params(url: url)[1][:query_params] }
  let(:request) do
    {
      config: config,
    }
  end
  let(:service)  { described_class }

  context 'with sparse fieldsets' do

    subject do
      service.handle_sparse_fieldsets(
        query_params: query_params,
        request:      request,
      )
    end

    context 'with valid types && valid fields' do
      let(:url) { 'https://domain.com/author?fields[author]=name,date_of_birth&fields[book]=title' }

      it 'add the expected data to the request' do
        status, ctx = subject
        expect(status).to eq :ok
        expect(ctx[:request][:fields]).to eq({ author: [:name, :date_of_birth], book: [:title] })
      end
    end

    context 'with an invalid type && an invalid field' do
      let(:url) { 'https://domain.com/author?fields[car]=names&fields[book]=cars' }

      it 'generates the proper errors' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Sparse fieldsets: `car` is not an available type'
        expect(ctx[:errors][1][:detail]).to eq 'Sparse fieldsets: `book`.`cars` is not an available field'
      end
    end

  end

end
