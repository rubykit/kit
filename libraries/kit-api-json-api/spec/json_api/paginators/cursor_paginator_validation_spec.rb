require_relative '../../rails_helper'

describe Kit::Api::JsonApi::Services::Paginators::Cursor::Validation do
  include_context 'config dummy app'

  let(:service)  { Kit::Api::JsonApi::Services::Request::Import::Pagination }

  let(:config)   { config_dummy_app }

  let(:query_params) { Kit::Api::JsonApi::Services::Url.parse_query_params(url: url)[1][:query_params] }
  let(:request) do
    {
      config:             config,
      top_level_resource: config[:resources][:author],
    }
  end

  subject do
    params = {
      query_params: query_params,
      request:      request,
    }
    Kit::Api::JsonApi::Services::Request::Import::RelatedResources.handle_related_resources(params)
    service.handle_pagination(params)
  end

  let(:status)      { subject[0] }
  let(:ctx)         { subject[1] }
  let(:first_error) { ctx[:errors][0][:detail] }

  let(:include_param) { '' }

  let(:url) { "https://domain.com/author?#{ include_param }#{ include_param.size > 0 ? '&' : '' }#{ page_param }" }

  context 'with invalid data' do

    context 'with unsupported keys' do
      let(:include_param) { 'include=books' }
      let(:page_param)    { 'page[size]=1&page[after]=cursor&page[books.lol]=3' }

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq 'Pagination error: unsupported keyword `lol` in `page[books.lol]`'
      end
    end

    context 'with unsupported values' do
      let(:page_param)    { 'page[size]=1,2' }

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq 'Pagination error: multiple values for `page[size]`'
      end
    end

    context 'with zero size' do
      let(:size)          { 0 }
      let(:page_param)    { "page[size]=#{ size }" }

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq "Pagination error: invalid value `#{ size }` for `page[size]`"
      end
    end

    context 'with negative size' do
      let(:size)          { -1 }
      let(:page_param)    { "page[size]=#{ size }" }

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq "Pagination error: invalid value `#{ size }` for `page[size]`"
      end
    end

    context 'with non integer size' do
      let(:size)          { 'ok' }
      let(:page_param)    { "page[size]=#{ size }" }

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq "Pagination error: invalid value `#{ size }` for `page[size]`"
      end
    end

    context 'with size superior to config[:page_size_max]' do
      let(:page_size_max) { config[:page_size_max] }
      let(:size)          { page_size_max + 1 }
      let(:page_param)    { "page[size]=#{ config[:page_size_max] + 1 }" }

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq "Pagination error: invalid value `#{ size }` for `page[size]`. The API maximum page size is: #{ page_size_max }"
      end
    end

    context 'with nil cursor' do
      let(:cursor)        { nil }
      let(:page_param)    { "page[after]=#{ cursor }" }

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq 'Pagination error: invalid cursor for `page[after]`'
      end
    end

    context 'with random cursor' do
      let(:cursor)        { 'ok' }
      let(:page_param)    { "page[before]=#{ cursor }" }

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq 'Pagination error: invalid cursor for `page[before]`'
      end
    end

    context 'with top level singular resource && 3rd level collection' do
      let(:include_param) { 'include=books.chapters' }
      let(:page_param)    { 'page[books.chapters.after]=val' }

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq 'Pagination error: can not use cursor pagination on path `books.chapters`'
      end
    end

    context 'with top level plural resource && 2nd level nested collections' do
      let(:include_param) { 'include=books' }
      let(:page_param)    { 'page[books.after]=val' }

      let(:request) do
        {
          config:             config,
          top_level_resource: config[:resources][:author],
          singular:           false,
        }
      end

      it 'generates the proper errors' do
        expect(status).to      eq :error
        expect(first_error).to eq 'Pagination error: can not use cursor pagination on path `books`'
      end
    end

  end

  context 'with valid data' do
    let(:cursor_data)   { { id: 6 } }
    let(:cursor)        { Kit::Api::JsonApi::Services::Encryption.encrypt(data: cursor_data, key: config[:meta][:kit_api_paginator_cursor][:encrypt_secret])[1][:encrypted_data] }

    context 'with valid top level cursor' do
      let(:page_param)    { "page[before]=#{ cursor }" }

      it 'generates the proper request[:pagination] data' do
        expect(status).to eq :ok
        expect(ctx[:request][:pagination][:top_level][:before]).to eq cursor_data
      end
    end

    context 'with valid relationship cursor' do
      let(:include_param) { 'include=books' }
      let(:page_param)    { "page[books.before]=#{ cursor }" }

      it 'generates the proper request[:pagination] data' do
        expect(status).to eq :ok
        expect(ctx[:request][:pagination]['books'][:before]).to eq cursor_data
      end
    end

  end

end
