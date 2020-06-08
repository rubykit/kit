require_relative '../../rails_helper'

describe Kit::Api::Services::QueryResolver do
  include_context 'config dummy app'

  let(:service)  { described_class }
  let(:singular) { false }

  let(:inclusion_level) { 3 }
  let(:config) do
    config_dummy_app.merge(
      inclusion_level: inclusion_level,
    )
  end

  let(:request) do
    {
      config:             config,
      top_level_resource: top_level_resource,
      singular:           singular,
    }
  end

  let(:query_node) do
    Kit::Api::Services::QueryBuilder.build_query(request: request)[1][:entry_query_node]
  end

  let(:subject) { service.resolve_query_node(query_node: query_node) }

  shared_examples 'a valid query plan is resolved' do
    it 'resolves the query plan' do
      status, ctx = subject
      qn          = ctx[:query_node]

      Kit::Api::Services::Debug.print_query(query_node: qn) if ENV['KIT_API_DEBUG']

      expect(status).to eq :ok
      expect(qn[:records].size).to be > 0
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
