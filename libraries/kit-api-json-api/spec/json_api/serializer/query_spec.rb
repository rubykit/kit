require_relative '../../rails_helper'

require 'oj'
require 'json'

describe Kit::Api::JsonApi::Services::Serializer::Query do
  let(:service)  { described_class }
  let(:config)   { Kit::Api::JsonApi::Services::Config.default_config }

  context 'for a top level resource' do
    list = [
      { resource: Kit::JsonApiSpec::Resources::Author.to_h    },
      { resource: Kit::JsonApiSpec::Resources::Book.to_h      },
      { resource: Kit::JsonApiSpec::Resources::BookStore.to_h },
      { resource: Kit::JsonApiSpec::Resources::Chapter.to_h   },
      { resource: Kit::JsonApiSpec::Resources::Photo.to_h     },
      { resource: Kit::JsonApiSpec::Resources::Serie.to_h     },
      { resource: Kit::JsonApiSpec::Resources::Store.to_h     },
    ]

    list.each do |resource:|
      it "serializes a collection of #{ resource[:name] }" do
        request = { config: config, top_level_resource: resource, singular: false }
        entry_query_node = Kit::Api::JsonApi::Services::QueryBuilder.build_query(request: request)[1][:query][:entry_query_node]
        Kit::Api::JsonApi::Services::QueryResolver.resolve_query_node(query_node: entry_query_node)

        status, ctx   = service.serialize_query(query_node: entry_query_node)
        json_response = ctx[:document][:response]

        #puts JSON.pretty_generate(json_response)

        expect(status).to eq :ok
        expect(json_response[:data]).to be_a(Array)
      end

      it "serializes a single #{ resource[:name] }" do
        request = { config: config, top_level_resource: resource, singular: true }
        entry_query_node = Kit::Api::JsonApi::Services::QueryBuilder.build_query(request: request)[1][:query][:entry_query_node]
        Kit::Api::JsonApi::Services::QueryResolver.resolve_query_node(query_node: entry_query_node)

        status, ctx   = service.serialize_query(query_node: entry_query_node)
        json_response = ctx[:document][:response]

        #puts JSON.pretty_generate(json_response)

        expect(status).to eq :ok
        expect(json_response[:data]).to be_a(Hash)
      end

    end
  end

end
