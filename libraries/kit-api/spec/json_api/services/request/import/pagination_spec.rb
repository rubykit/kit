require_relative '../../../../rails_helper'

describe Kit::Api::JsonApi::Services::Request::Import::Pagination do
  include_context 'config dummy app'

  let(:service)  { described_class }

  let(:config)   { config_dummy_app }

  let(:query_params) { Kit::Api::JsonApi::Services::Url.parse_query_params(url: url)[1][:query_params] }
  let(:api_request) do
    {
      config:             config,
      top_level_resource: config[:resources][:author],
    }
  end

  subject do
    params = {
      query_params: query_params,
      api_request:  api_request,
    }
    Kit::Api::JsonApi::Services::Request::Import::RelatedResources.handle_related_resources(params)
    service.handle_pagination(params)
  end

  let(:url) { "https://domain.com/author?#{ include_param }&#{ page_param }" }

  context 'with invalid include && valid page criteria' do
    let(:include_param) { 'include=books.serie' }
    let(:page_param)    { 'page[size]=1&page[books.chapters.size]=3' }

    it 'generates the proper errors' do
      status, ctx = subject
      expect(status).to eq :error
      expect(ctx[:errors][0][:detail]).to eq 'Page: `books.chapters` is not an included relationship'
    end
  end

  context 'with valid include && valid page criteria' do

    context 'with two different paginators' do

      let(:config) do
        config    = config_dummy_app
        resources = config[:resources]

        resources[:author][:paginator]  = fake_paginator_1
        resources[:book][:paginator]    = fake_paginator_2
        resources[:chapter][:paginator] = fake_paginator_1
        resources[:serie][:paginator]   = fake_paginator_2

        config
      end

      let(:fake_paginator_1) do
        {
          type:   :fake_paginator_1,
          import: ->(api_request:, parsed_query_params_page:) do
            parsed_query_params_page.each do |_path, hash|
              hash[:fp1] = hash[:fp1][0].to_i + 1
              if hash[:fp2] # Meant to catch failure
                hash[:fp2] = hash[:fp2][0].to_i + 10
              end
            end

            [:ok, parsed_query_params_page: parsed_query_params_page]
          end,
        }
      end

      let(:fake_paginator_2) do
        {
          type:   :fake_paginator_2,
          import: ->(api_request:, parsed_query_params_page:) do
            parsed_query_params_page.each do |_path, hash|
              hash[:fp2] = hash[:fp2][0].to_i + 2
              if hash[:fp1] # Meant to catch failure
                hash[:fp1] = hash[:fp1][0].to_i + 20
              end
            end

            [:ok, parsed_query_params_page: parsed_query_params_page]
          end,
        }
      end

      let(:include_param) { 'include=books.serie,books.chapters' }
      let(:page_param) do
        {
          'page[fp1]'                => 10,
          'page[books.fp2]'          => 20,
          'page[books.chapters.fp1]' => 10,
          'page[books.serie.fp2]'    => 20,
        }.map { |k, v| "#{ k }=#{ v }" }.join('&')
      end

      it 'add the expected pagination data to the request' do
        status, ctx = subject

        expect(status).to eq :ok
        expect(ctx[:api_request][:pagination]).to eq({
          :top_level       => { fp1: 11 },
          'books'          => { fp2: 22 },
          'books.chapters' => { fp1: 11 },
          'books.serie'    => { fp2: 22 },
        })
      end

    end

  end

end
