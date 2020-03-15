require_relative '../../rails_helper'

require 'oj'
require 'json'

describe Kit::JsonApi::Services::Serializer::Query do
  let(:service)  { described_class }

  context 'for a top level resource' do

    it "serializes a Query with nested collections with different modifiers" do
      # Author > Books > Author > Books
      resource    = Kit::JsonApiSpec::Resources::Author.resource
      query_node1 = Kit::JsonApi::Services::QueryBuilder.build_query(resource: resource, singular: true)[1][:query_node]
      query_node2 = query_node1[:relationship_query_nodes][:books]
      query_node3 = query_node1.dup
      query_node4 = query_node2.dup

      query_node2[:limit] = 2

      query_node2[:relationship_query_nodes][:author] = query_node3
      query_node3[:parent_query_node] = query_node2
      query_node3[:parent_relationship_name] = :author

      query_node3[:condition] = query_node2[:resource][:relationships][:author][:inherited_filter]
      query_node3[:singular]  = false

      query_node3[:relationship_query_nodes] = { books: query_node4 }
      query_node4[:parent_query_node] = query_node3
      query_node4[:parent_relationship_name] = :books

      query_node4[:relationship_query_nodes] = {}

      Kit::JsonApi::Services::QueryResolver.resolve_query_node(query_node: query_node1)[1][:query_node]
      #top_query_node = Kit::JsonApi::Services::QueryResolver.resolve_query_node(query_node: top_query_node)[1][:query_node]

      status, ctx = service.serialize_query(query_node: query_node1)

      puts JSON.pretty_generate(ctx[:document][:response])

      expect(status).to eq :ok
    end

  end

end