require_relative '../../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Export::Pagination do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config)   { config_dummy_app }

  let(:api_request) do
    {
      config:             config,
      top_level_resource: Kit::JsonApiSpec::Resources::Author.to_h,
    }
  end

  let(:url) { "https://domain.com/author?#{ query_params_str }" }

  let(:query_params_str_out) do
    qp = ctx[:query_params].select { |k, _v| k == :page }
    Kit::Api::JsonApi::Services::Url.serialize_query_params(query_params: qp)[1][:query_params_str]
  end

  subject do
    Kit::Organizer.call(
      list: [
        Kit::Api::JsonApi::Services::Url.method(:parse_query_params),
        Kit::Api::JsonApi::Services::Request::Import::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Import::Pagination.method(:handle_pagination),
        -> { [:ok, query_params: {}] },
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:included_paths),
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Export::Pagination.method(:handle_page_size),
      ],
      ctx:  { api_request: api_request, url: url, path: path },
    )
  end

  let(:status) { subject[0] }
  let(:ctx)    { subject[1] }

  describe '.handle_page_size' do
    let(:query_params_str) { 'include=books.chapters&page[size]=1&page[books.size]=2&page[books.chapters.size]=3' }

    context 'existing filters for top level' do
      let(:path) { '' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:page]).to eq({
          'size'                => 1,
          'books.size'          => 2,
          'books.chapters.size' => 3,
        })

        expect(query_params_str_out).to eq 'page[size]=1&page[books.size]=2&page[books.chapters.size]=3'
      end
    end

    context 'existing filters for nested level' do
      let(:path) { 'books' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:page]).to eq({
          'size'          => 2,
          'chapters.size' => 3,
        })

        expect(query_params_str_out).to eq 'page[size]=2&page[chapters.size]=3'
      end
    end

    context 'no filters for nested level' do
      let(:path) { 'series' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:page]).to be nil
      end
    end

  end

end
