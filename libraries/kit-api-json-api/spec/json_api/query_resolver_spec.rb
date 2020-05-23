require_relative '../rails_helper'

describe Kit::Api::JsonApi::Services::QueryResolver do
  include_context 'config dummy app'

  let(:service)  { described_class }
  let(:singular) { false }
  let(:config)   { config_dummy_app }

  shared_examples 'a valid query plan is resolved' do
    it 'resolves the query plan' do
      request      = { config: config, top_level_resource: top_level_resource, singular: singular }
      query_node   = Kit::Api::JsonApi::Services::QueryBuilder.build_query(request: request)[1][:entry_query_node]
      status, _ctx = service.resolve_query_node(query_node: query_node)

      expect(status).to eq :ok
    end
  end

  context 'for a top level resource' do

    context 'that is an Author' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Author.to_h }
      it_behaves_like 'a valid query plan is resolved'
    end

    context 'that is a Book' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Book.to_h }
      it_behaves_like 'a valid query plan is resolved'
    end

    context 'that is a BookStore' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::BookStore.to_h }
      it_behaves_like 'a valid query plan is resolved'
    end

    context 'that is a Chapter' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Chapter.to_h }
      it_behaves_like 'a valid query plan is resolved'
    end

    context 'that is a Photo' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Photo.to_h }
      it_behaves_like 'a valid query plan is resolved'
    end

    context 'that is a Serie' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Serie.to_h }
      it_behaves_like 'a valid query plan is resolved'
    end

    context 'that is a Store' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Store.to_h }
      it_behaves_like 'a valid query plan is resolved'
    end

  end

end