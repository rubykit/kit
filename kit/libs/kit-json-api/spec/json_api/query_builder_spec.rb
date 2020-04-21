require_relative '../rails_helper'

describe Kit::JsonApi::Services::QueryBuilder do
  let(:service)  { described_class }
  let(:singular) { false }

  let(:request) do
    {
      top_level_resource: top_level_resource,
      singular:           singular,
    }
  end

  shared_examples "a valid query plan is generated" do
    it "generates a valid query plan" do
      status, ctx = service.build_query(request: request)
      query       = ctx[:query]
      query_node  = query[:entry_query_node]

      expect(status).to eq :ok
      expect(query_node[:relationships].count).to eq(top_level_resource[:relationships].count)

      top_level_resource[:relationships].each do |relationship_name, relationship|
        next if relationship[:inclusion_level] < 1

        qn_relationship = query_node[:relationships][relationship_name]

        expect(qn_relationship[:name]).to eq(relationship_name)
        expect(qn_relationship[:parent_query_node]).to eq(query_node)
        expect(qn_relationship[:child_query_node]).to be_a(Kit::JsonApi::Types::QueryNode)
      end
    end
  end

  context 'for a top level resource' do

    context 'that is an Author' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Author.resource }
      it_behaves_like "a valid query plan is generated"
    end

    context 'that is a Book' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Book.resource }
      it_behaves_like "a valid query plan is generated"
    end

    context 'that is a BookStore' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::BookStore.resource }
      it_behaves_like "a valid query plan is generated"
    end

    context 'that is a Chapter' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Chapter.resource }
      it_behaves_like "a valid query plan is generated"
    end

    context 'that is a Photo' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Photo.resource }
      it_behaves_like "a valid query plan is generated"
    end

    context 'that is a Serie' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Serie.resource }
      it_behaves_like "a valid query plan is generated"
    end

    context 'that is a Store' do
      let(:top_level_resource) { Kit::JsonApiSpec::Resources::Store.resource }
      it_behaves_like "a valid query plan is generated"
    end

  end

end