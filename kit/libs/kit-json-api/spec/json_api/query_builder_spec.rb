require_relative '../rails_helper'

describe Kit::JsonApi::Services::QueryBuilder do
  let(:service)  { described_class }
  let(:singular) { false }

  context 'for a top level resource' do
    list = [
      { resource: Kit::JsonApiSpec::Resources::Author.resource,    },
      { resource: Kit::JsonApiSpec::Resources::Book.resource,      },
      { resource: Kit::JsonApiSpec::Resources::BookStore.resource, },
      { resource: Kit::JsonApiSpec::Resources::Chapter.resource,   },
      { resource: Kit::JsonApiSpec::Resources::Photo.resource,     },
      { resource: Kit::JsonApiSpec::Resources::Serie.resource,     },
      { resource: Kit::JsonApiSpec::Resources::Store.resource,     },
    ]

    list.each do |resource:|
      it "generates a valid query plan for #{resource[:name]}" do
        status, ctx = service.build_query(resource: resource, singular: singular)
        query       = ctx[:query]
        query_node  = query[:entry_query_node]

        expect(status).to eq :ok
        expect(query_node[:relationships].count).to eq(resource[:relationships].count)

        resource[:relationships].each do |relationship_name, relationship|
          next if relationship[:inclusion_level] < 1

          qn_relationship = query_node[:relationships][relationship_name]

          expect(qn_relationship[:name]).to eq(relationship_name)
          expect(qn_relationship[:parent_query_node]).to eq(query_node)
          expect(qn_relationship[:child_query_node]).to be_a(Kit::JsonApi::Types::QueryNode)
        end
      end
    end
  end

end