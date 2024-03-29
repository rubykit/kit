require_relative '../../../rails_helper'

describe Kit::Api::JsonApi::Services::Serialization::Query do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config) do
    config_dummy_app.merge(
      inclusion_level: 4,
    )
  end

  let(:top_level_resource) { config[:resources][:author] }

  let(:api_request) do
    {
      config:             config,
      top_level_resource: top_level_resource,
      singular:           true,
      related_resources:  {
        'books'              => config[:resources][:book],
        'books.author'       => config[:resources][:author],
        'books.author.books' => config[:resources][:book],
      },
      sparse_fieldsets:   {},
      sorting:            {},
      filtering:          {},
      pagination:         {
        'books'              => { size: 2 },
        'books.author.books' => { size: 3 },
      },
    }
  end

  context 'for a top level resource' do

    it 'serializes a Query with nested collections with different modifiers' do
      # Author > Books > Author > Books
      query_node = Kit::Api::Services::QueryBuilder.build_query(api_request: api_request)[1][:query_node]

      Kit::Api::Services::QueryResolver.resolve_query_node(query_node: query_node)

      status, ctx = service.serialize_query(query_node: query_node)
      response    = ctx[:document][:response]

      expect(status).to eq :ok

      expect(response[:data][:relationships]['books'][:data].size).to eq 2
      expect(response[:data][:relationships]['books.author.books'][:data].size).to eq 3
    end

  end

end
