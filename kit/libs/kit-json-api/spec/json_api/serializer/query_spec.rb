require_relative '../../rails_helper'

require 'oj'
require 'json'

describe Kit::JsonApi::Services::Serializer::Query do
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
      it "serializes a collection of #{resource[:name]}" do
        request = { top_level_resource: resource, singular: false }
        entry_query_node = Kit::JsonApi::Services::QueryBuilder.build_query(request: request)[1][:query][:entry_query_node]
        Kit::JsonApi::Services::QueryResolver.resolve_query_node(query_node: entry_query_node)

        status, ctx   = service.serialize_query(query_node: entry_query_node)
        json_response = ctx[:document][:response]

        #puts JSON.pretty_generate(json_response)

        expect(status).to eq :ok
        expect(json_response[:data]).to be_a(Array)
      end

      it "serializes a single #{resource[:name]}" do
        request = { top_level_resource: resource, singular: true }
        entry_query_node = Kit::JsonApi::Services::QueryBuilder.build_query(request: request)[1][:query][:entry_query_node]
        Kit::JsonApi::Services::QueryResolver.resolve_query_node(query_node: entry_query_node)

        status, ctx   = service.serialize_query(query_node: entry_query_node)
        json_response = ctx[:document][:response]

        #puts JSON.pretty_generate(json_response)

        expect(status).to eq :ok
        expect(json_response[:data]).to be_a(Hash)
      end

    end
  end

end