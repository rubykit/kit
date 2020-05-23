require_relative '../rails_helper'

describe Kit::Api::JsonApi::Services::QueryBuilder do
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

  let(:subject) { service.build_query(request: request) }

  shared_examples 'a valid query plan is generated' do
    it 'generates a valid query plan' do
      status, ctx = subject
      query_node  = ctx[:entry_query_node]

      #Kit::Api::JsonApi::Services::Debug.print_query(query_node: qn)

      expect(status).to eq :ok
      expect(query_node[:resource]).to eq top_level_resource

      relationships_specs = ->(current_query_node:, level:) do

        current_resource = current_query_node[:resource]

        if level < max_level
          expect(current_query_node[:relationships].count).to eq(current_resource[:relationships].count)
        else
          expect(current_query_node[:relationships].count).to eq 0
          return
        end

        # Validate current level
        current_resource[:relationships].each do |relationship_name, relationship|
          qn_relationship = current_query_node[:relationships][relationship_name]

          parent_query_node = qn_relationship[:parent_query_node]
          child_query_node  = qn_relationship[:child_query_node]

          expect(qn_relationship[:name]).to eq(relationship_name)
          expect(parent_query_node).to      eq(current_query_node)
          expect(child_query_node[:resource][:name]).to eq(request[:config][:resources][relationship[:resource]][:name])
          expect(child_query_node[:condition]).not_to be nil
        end

        # Now recurse
        current_resource[:relationships].each do |relationship_name, _relationship|
          qn_relationship  = current_query_node[:relationships][relationship_name]
          child_query_node = qn_relationship[:child_query_node]

          relationships_specs.call(current_query_node: child_query_node, level: level + 1)
        end
      end

      relationships_specs.call(current_query_node: query_node, level: 1)
    end
  end

  context 'for a top level resource' do

    context 'that is an Author' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Author.to_h }
      it_behaves_like 'a valid query plan is generated'
    end

    context 'that is a Book' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Book.to_h }
      it_behaves_like 'a valid query plan is generated'
    end

    context 'that is a BookStore' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::BookStore.to_h }
      it_behaves_like 'a valid query plan is generated'
    end

    context 'that is a Chapter' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Chapter.to_h }
      it_behaves_like 'a valid query plan is generated'
    end

    context 'that is a Photo' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Photo.to_h }
      it_behaves_like 'a valid query plan is generated'
    end

    context 'that is a Serie' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Serie.to_h }
      it_behaves_like 'a valid query plan is generated'
    end

    context 'that is a Store' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Store.to_h }
      it_behaves_like 'a valid query plan is generated'
    end

  end

end
