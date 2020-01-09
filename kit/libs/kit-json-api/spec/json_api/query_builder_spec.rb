require_relative '../rails_helper'

describe Kit::JsonApi::Services::QueryBuilder do
  let(:service)  { described_class }

  let(:resource) { Kit::JsonApiSpec::Resources::Author.resource }

  context 'Resolve query' do
    subject { service.build_query(resource: resource) }

    it 'works' do
      status, ctx = subject
      expect(status).to eq :ok

      query_node = ctx[:query_node]
      expect(query_node[:parent]).to be nil

      rs1 = query_node[:relationships][:books]
      expect(rs1).not_to be_nil
    end
  end

end