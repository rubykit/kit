require_relative '../rails_helper'

describe Kit::JsonApi::Services::QueryBuilder do
  let(:service)  { described_class }
  let(:singular) { false }

  context 'for a top level resource' do
    list = [
      { resource: Kit::JsonApiSpec::Resources::Author.resource,    included_relationships_count: 3, },
      { resource: Kit::JsonApiSpec::Resources::Book.resource,      included_relationships_count: 3, },
      { resource: Kit::JsonApiSpec::Resources::BookStore.resource, included_relationships_count: 2, },
      { resource: Kit::JsonApiSpec::Resources::Chapter.resource,   included_relationships_count: 1, },
      { resource: Kit::JsonApiSpec::Resources::Photo.resource,     included_relationships_count: 3, },
      { resource: Kit::JsonApiSpec::Resources::Serie.resource,     included_relationships_count: 3, },
      { resource: Kit::JsonApiSpec::Resources::Store.resource,     included_relationships_count: 0, },
    ]

    list.each do |resource:, included_relationships_count:|
      it "generates a valid query plan for #{resource[:name]}" do
        status, ctx = service.build_query(resource: resource, singular: singular)
        query_node  = ctx[:query_node]

        expect(status).to eq :ok
        expect(query_node[:relationship_query_nodes].count).to eq(included_relationships_count)

        resource[:relationships].each do |rs_name, rs_data|
          next if !rs_data[:inclusion][:top_level]

          expect(query_node[:relationship_query_nodes][rs_name]).to be_a(Kit::JsonApi::Types::QueryNode)
        end
      end
    end
  end

end