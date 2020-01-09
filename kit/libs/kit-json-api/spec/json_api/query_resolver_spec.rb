require_relative '../rails_helper'

describe Kit::JsonApi::Services::QueryResolver do
  let(:service)        { described_class }
  let(:resource)       { Kit::JsonApiSpec::Resources::Author.resource }
  let(:top_query_node) { Kit::JsonApi::Services::QueryBuilder.build_query(resource: resource)[1][:query_node] }

  context 'Resolve query' do
    subject { service.resolve_query(query_node: top_query_node) }

    it 'works' do
      status, ctx = subject
      expect(status).to eq :ok
    end
  end

end