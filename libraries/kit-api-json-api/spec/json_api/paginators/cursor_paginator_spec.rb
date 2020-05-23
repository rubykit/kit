require_relative '../../rails_helper'

=begin
describe Kit::Api::JsonApi::Services::QueryBuilder do
  let(:service)   { described_class }
  let(:singular)  { false }
  let(:paginator) { Kit::Api::JsonApi::Services::Resolvers::CursorPaginator }
  let(:config)    { Kit::Api::JsonApi::Services::Config.default_config(paginator: paginator) }

  let(:request) do
    {
      config:             config,
      top_level_resource: top_level_resource,
      singular:           singular,
    }
  end

  let(:subject) { service.build_query(request: request) }

  shared_examples 'a valid query plan is generated' do

  end

  context 'for a top level resource' do

    context 'that is an Author' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Author.to_h }
      it_behaves_like 'a valid query plan is generated'

      it 'generates a valid query plan' do
        status, ctx = subject
        query       = ctx[:query]
        query_node  = query[:entry_query_node]

        expect(status).to eq :ok
        expect(query_node[:relationships].count).to eq(top_level_resource[:relationships].count)

        top_level_resource[:relationships].each do |relationship_name, relationship|
          next if relationship[:inclusion_level] < 1

          qn_relationship = query_node[:relationships][relationship_name]

          expect(qn_relationship[:name]).to eq(relationship_name)
          expect(qn_relationship[:parent_query_node]).to eq(query_node)
          #expect(qn_relationship[:child_query_node]).to be_a(Kit::Api::JsonApi::Types::QueryNode)
        end
      end
    end

  end

end
=end
