require_relative '../../../rails_helper'

describe Kit::Api::JsonApi::Services::Serialization::Query do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config)   { config_dummy_app }

  let(:request) do
    {
      config:             config,
      top_level_resource: top_level_resource,
      singular:           singular,
    }
  end

  let(:subject) do
    entry_query_node = Kit::Api::Services::QueryBuilder.build_query(request: request)[1][:entry_query_node]
    Kit::Api::Services::QueryResolver.resolve_query_node(query_node: entry_query_node)

    service.serialize_query(query_node: entry_query_node)
  end

  shared_examples 'a resource is correctly serialized as a collection' do
    let(:singular) { false }

    it 'serializes correctly' do
      status, ctx   = subject
      json_response = ctx[:document][:response]

      puts JSON.pretty_generate(json_response) if ENV['KIT_API_DEBUG']

      expect(status).to eq :ok
      expect(json_response[:data]).to be_a(Array)
    end
  end

  shared_examples 'a resource is correctly serialized as a single object' do
    let(:singular) { true }

    it 'serializes correctly' do
      status, ctx   = subject
      json_response = ctx[:document][:response]

      puts JSON.pretty_generate(json_response) if ENV['KIT_API_DEBUG']

      expect(status).to eq :ok
      expect(json_response[:data]).to be_a(Hash)
    end
  end

  context 'for a top level resource' do

    context 'that is an Author' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Author.to_h }
      it_behaves_like 'a resource is correctly serialized as a collection'
      it_behaves_like 'a resource is correctly serialized as a single object'
    end

    context 'that is a Book' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Book.to_h }
      it_behaves_like 'a resource is correctly serialized as a collection'
      it_behaves_like 'a resource is correctly serialized as a single object'
    end

    context 'that is a BookStore' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::BookStore.to_h }
      it_behaves_like 'a resource is correctly serialized as a collection'
      it_behaves_like 'a resource is correctly serialized as a single object'
    end

    context 'that is a Chapter' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Chapter.to_h }
      it_behaves_like 'a resource is correctly serialized as a collection'
      it_behaves_like 'a resource is correctly serialized as a single object'
    end

    context 'that is a Photo' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Photo.to_h }
      it_behaves_like 'a resource is correctly serialized as a collection'
      it_behaves_like 'a resource is correctly serialized as a single object'
    end

    context 'that is a Serie' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Serie.to_h }
      it_behaves_like 'a resource is correctly serialized as a collection'
      it_behaves_like 'a resource is correctly serialized as a single object'
    end

    context 'that is a Store' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Store.to_h }
      it_behaves_like 'a resource is correctly serialized as a collection'
      it_behaves_like 'a resource is correctly serialized as a single object'
    end

  end

end
