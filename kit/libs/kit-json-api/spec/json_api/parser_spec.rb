require_relative '../rails_helper'

require 'uri'
require 'Rack'

=begin
describe Kit::JsonApi::Services::Url::Parser do
  let(:service)  { described_class }
  let(:singular) { false }

  context 'for a filters' do
    let(:url) { 'https://domain.com/author?filter[id]=1,2,3&filter[books.id]=4'}

    context 'with a url' do
      it 'extracts & format the query params correctly' do
        status, ctx = service.parse_url(url: url)
        expect(status).to eq :ok
      end
    end

    context 'with query parameters' do
      let(:query_params) { Rack::Utils::parse_nested_query(URI(url).query) }

      it 'extracts & format the query params correctly' do
        status, ctx = service.parse_query_params(query_params: query_params)
        expect(status).to eq :ok
      end
    end
  end

end
=end