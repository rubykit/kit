require_relative '../rails_helper'

describe Kit::Api::JsonApi::Services::QueryResolver do
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
        request     = { top_level_resource: resource, singular: singular, }

        query_node  = Kit::Api::JsonApi::Services::QueryBuilder.build_query(request: request)[1][:query][:entry_query_node]

        status, ctx = service.resolve_query_node(query_node: query_node)

        expect(status).to eq :ok
      end
    end
  end

end