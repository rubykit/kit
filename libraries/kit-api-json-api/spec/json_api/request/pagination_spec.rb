require_relative '../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Pagination do
  let(:service)  { described_class }

  let(:config) do
    {
      resources: {
        book:   Kit::JsonApiSpec::Resources::Book.to_h,
        author: Kit::JsonApiSpec::Resources::Author.to_h,
      },
    }
  end

  let(:query_params) { Kit::Api::JsonApi::Services::Url.parse_query_params(url: url)[1][:query_params] }
  let(:request) do
    {
      config:             config,
      top_level_resource: Kit::JsonApiSpec::Resources::Author.to_h,
    }
  end

  context 'with sort order' do

    subject do
      params = {
        query_params: query_params,
        request:      request,
      }
      Kit::Api::JsonApi::Services::Request::RelatedResources.handle_related_resources(params)
      service.handle_filtering(params)
    end

    let(:valid_include)   { 'include=books' }
    let(:invalid_include) { 'include=series' }

    let(:valid_filters)   { 'filter[name][eq]=Tolkien,Rowling&filter[books.date_published][lt]=2002&filter[date_of_birth][gt]=1950&filter[books.title]=Title' }

    context 'with valid include && valid filter criteria' do
      let(:url) { "https://domain.com/author?#{ valid_include }&#{ valid_filters }" }

      it 'add the expected data to the request' do
        status, ctx = subject

        expect(status).to eq :ok
        expect(ctx[:request][:related_resources].keys).to eq ['books']
        expect(ctx[:request][:filters]).to eq({
          :top_level => [
            { name: :name,           op: :in, value: %w[Tolkien Rowling] },
            { name: :date_of_birth,  op: :gt, value: ['1950'] },
          ],
          'books'    => [
            { name: :date_published, op: :lt, value: ['2002'] },
            { name: :title,          op: :eq, value: ['Title'] },
          ],
        })
      end
    end

    context 'with invalid include && valid filter criteria' do
      let(:url) { "https://domain.com/author?#{ invalid_include }&#{ valid_filters }" }

      it 'generates the proper errors' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Filter: `books` is not an included relationship'
      end
    end

    context 'with valid include && non existing filter' do
      let(:url) { 'https://domain.com/author?filter[lol]=Tolkien' }

      it 'generates the proper errors' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Filter: `lol` is not a valid filter'
      end
    end

    context 'with valid include && non existing operator' do
      let(:url) { 'https://domain.com/author?filter[name][lol]=Tolkien' }

      it 'generates the proper errors' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Filter: `name` does not support operator `lol`'
      end
    end

  end

end
