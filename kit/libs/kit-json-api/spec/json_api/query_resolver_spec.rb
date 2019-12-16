require_relative '../rails_helper'

describe Kit::JsonApi::Services::QueryResolver do
  let(:service)       { described_class }

  let(:json_api_query) do
    author_resource = Kit::JsonApiSpec::Resources::Author.resource
    query_node       = {
      resource:      author_resource,
      relationships: {},
      filters:       [[]],
      sorting:       [[:id, :desc]],
      limit:         5,
      data:          nil,
      meta:          {},
      data_loader:   author_resource[:data_loader],
    }

    json_api_query  = {
      fields: {
        Kit::JsonApiSpec::Resources::Author => author_resource[:available_fields].map(&:first),
      },
      entry_node: query_node
    }
  end


  context 'Resolve query' do
    subject { service.resolve_query(json_api_query: json_api_query) }

    it 'works' do
      status, ctx = subject
      expect(status).to eq :ok
    end
  end

end