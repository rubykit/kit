require_relative '../rails_helper'

describe Kit::JsonApi::Services::QueryResolver do
  let(:service)  { described_class }

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
        top_query_node = Kit::JsonApi::Services::QueryBuilder.build_query(resource: resource)[1][:query_node]

        status, ctx    = service.resolve_query_node(query_node: top_query_node)

        expect(status).to eq :ok
      end
    end
  end

end