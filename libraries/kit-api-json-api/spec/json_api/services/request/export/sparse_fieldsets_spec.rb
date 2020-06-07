require_relative '../../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Export::SparseFieldsets do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config)   { config_dummy_app }

  let(:request) do
    {
      config:             config,
      top_level_resource: Kit::JsonApiSpec::Resources::Author.to_h,
    }
  end

  let(:url) { "https://domain.com/author?#{ query_params_str }" }

  let(:query_params_str_out) do
    qp = ctx[:query_params].select { |k, _v| k == :fields }
    Kit::Api::JsonApi::Services::Url.serialize_query_params(query_params: qp)[1][:query_params_str]
  end

  subject do
    Kit::Organizer.call({
      list: [
        Kit::Api::JsonApi::Services::Url.method(:parse_query_params),
        Kit::Api::JsonApi::Services::Request::Import::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Import::SparseFieldsets.method(:handle_sparse_fieldsets),
        -> { [:ok, query_params: {}] },
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:included_paths),
        Kit::Api::JsonApi::Services::Request::Export::RelatedResources.method(:handle_related_resources),
        Kit::Api::JsonApi::Services::Request::Export::SparseFieldsets.method(:handle_sparse_fieldsets),
      ],
      ctx:  { request: request, url: url, path: path },
    })
  end

  let(:status) { subject[0] }
  let(:ctx)    { subject[1] }

  describe '.handle_sparse_fieldsets' do
    let(:query_params_str) { 'include=books&fields[author]=name,date_of_birth&fields[book]=title' }

    context 'existing filters for top level' do
      let(:path) { '' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:fields]).to eq({
          'author' => 'name,date_of_birth',
          'book'   => 'title',
        })

        expect(query_params_str_out).to eq 'fields[author]=name%2Cdate_of_birth&fields[book]=title'
      end
    end

    context 'existing filters for nested level' do
      let(:path) { 'books' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:fields]).to eq({
          'book' => 'title',
        })

        expect(query_params_str_out).to eq 'fields[book]=title'
      end
    end

    context 'no filters for nested level' do
      let(:path) { 'series' }

      it 'generates the correct query_params' do
        expect(ctx[:query_params][:fields]).to be nil
      end
    end

  end

end
