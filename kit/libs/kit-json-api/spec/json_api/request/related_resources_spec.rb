require_relative '../../rails_helper'

describe Kit::JsonApi::Services::Request::RelatedResources do
  let(:service)  { described_class }

  let(:config) do
    Kit::JsonApi::Types::Config[
      resources: {
        books:   Kit::JsonApiSpec::Resources::Book.resource,
        authors: Kit::JsonApiSpec::Resources::Author.resource,
        series:  Kit::JsonApiSpec::Resources::Serie.resource,
      },
    ]
  end

  let(:query_params) { Kit::JsonApi::Services::Parser.parse_url(url: url)[1][:query_params] }
  let(:request) do
    Kit::JsonApi::Types::Request[
      top_level_resource: Kit::JsonApiSpec::Resources::Author.resource,
    ]
  end

  context 'with related resources' do

    subject do
      service.handle_related_resources(
        config:       config,
        query_params: query_params,
        request:      request,
      )
    end

    context 'with valid types && valid fields' do
      let(:url) { 'https://domain.com/author?include=books.author.books,series.books' }

      it 'add the expected data to the request' do
        status, ctx = subject
        expect(status).to eq :ok
        expect(ctx[:request][:related_resources]).to eq({
          'books'              => true,
          'books.author'       => true,
          'books.author.books' => true,
          'series'             => true,
          'series.books'       => true,
        })
      end
    end

    context 'with an invalid relationship' do
      let(:url) { 'https://domain.com/author?include=books.author.cars'}

      it 'generates the proper errors' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq "Related resource: `books.author.cars` is not a valid relationship"
      end
    end

  end

end