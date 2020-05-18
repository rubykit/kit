require_relative '../../rails_helper'

describe Kit::Api::JsonApi::Services::QueryBuilder do
  let(:service)  { described_class }
  let(:singular) { false }
  let(:config)   { Kit::Api::JsonApi::Services::Config.default_config }

  let(:top_level_resource) { Kit::JsonApiSpec::Resources::Author.resource }

  let(:request) do
    {
      top_level_resource: top_level_resource,
      singular:           singular,
      related_resources:  {
        'books'        => true,
        'books.author' => true,
      },
      sparse_fieldsets:   {},
      sorting:            {},
      filtering:          {},
      pagination:         {},
      limit:              {},
    }
  end

  context 'for a ' do
    it 'generates a valid nested query plan' do
      status, ctx = service.build_query(config: config, request: request)
      query       = ctx[:query]
      query_node  = query[:entry_query_node]

      expect(status).to eq :ok
      expect(query_node[:relationships].keys).to eq [:books]

      books_node = query_node[:relationships].dig(:books, :child_query_node)
      expect(books_node).not_to be nil
      expect(books_node[:relationships].keys).to eq [:author]
    end

  end

end
