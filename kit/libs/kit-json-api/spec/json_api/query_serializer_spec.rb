require_relative '../rails_helper'

require 'oj'
require 'json'

describe Kit::JsonApi::Services::QuerySerializer do
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
      it "serializes #{resource[:name]}" do
        top_query_node = Kit::JsonApi::Services::QueryBuilder.build_query(resource: resource)[1][:query_node]
        top_query_node = Kit::JsonApi::Services::QueryResolver.resolve_query_node(query_node: top_query_node)[1][:query_node]

        status, ctx = service.serialize_query(query_node: top_query_node)

        puts JSON.pretty_generate(ctx[:document][:response])

        expect(status).to eq :ok
      end
    end
  end

end