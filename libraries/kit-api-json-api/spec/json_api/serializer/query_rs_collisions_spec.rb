require_relative '../../rails_helper'

require 'oj'
require 'json'

describe Kit::Api::JsonApi::Services::Serializer::Query do
  let(:service)  { described_class }
  let(:config)   { Kit::Api::JsonApi::Services::Config.default_config }

  let(:top_level_resource) { Kit::JsonApiSpec::Resources::Author.to_h }

  let(:request) do
    {
      config:             config,
      top_level_resource: top_level_resource,
      singular:           true,
      related_resources:  {
        'books'              => true,
        'books.author'       => true,
        'books.author.books' => true,
      },
      sparse_fieldsets:   {},
      sorting:            {},
      filtering:          {},
      pagination:         {},
      limit:              {
        'books'              => 2,
        'books.author.books' => 3,
      },
    }
  end

  context 'for a top level resource' do

    it 'serializes a Query with nested collections with different modifiers' do
      # Author > Books > Author > Books
      query_node = Kit::Api::JsonApi::Services::QueryBuilder.build_query(request: request)[1][:query][:entry_query_node]

      Kit::Api::JsonApi::Services::QueryResolver.resolve_query_node(query_node: query_node)

      status, ctx = service.serialize_query(query_node: query_node)
      response    = ctx[:document][:response]

      puts JSON.pretty_generate(ctx[:document][:response])

      expect(status).to eq :ok

      expect(response[:data][:relationships]['books'][:data].size).to eq 2
      expect(response[:data][:relationships]['books.author.books'][:data].size).to eq 3
    end

  end

end
