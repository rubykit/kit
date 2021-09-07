require_relative '../../rails_helper'

describe 'Json:Api requests Headers', type: :request do
  include_context 'json:api'

  let(:path)    { Kit::Router::Adapters::Http::Mountpoints.path(id: 'specs|api|author|index') }
  let(:subject) { get path, headers: headers }

  let(:other_accept)       { 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' }
  let(:valid_accept)       { "text/html,#{ jsonapi_media_type },application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" }

  let(:valid_content_type) { jsonapi_media_type }
  let(:other_content_type) { 'text/html; charset=UTF-8' }

  before { subject }

  context 'valid headers' do
    let(:headers) { jsonapi_headers }

    it 'returns the correct Status code' do
      expect(response.status).to eq 200
    end
  end

  context 'invalid headers' do

    context 'without the expected CONTENT-TYPE header' do

      context 'missing header' do
        let(:headers) do
          { 'ACCEPT' => valid_accept }
        end

        it 'returns the correct Status code' do
          expect(response.status).to eq 415
        end
      end

      context 'missing json:api media type' do
        let(:headers) do
          {
            'ACCEPT'       => valid_accept,
            'CONTENT-TYPE' => other_content_type,
          }
        end

        it 'returns the correct Status code' do
          expect(response.status).to eq 415
        end
      end

    end

    context 'without the expected ACCEPT header' do

      context 'missing header' do
        let(:headers) do
          { 'CONTENT-TYPE' => valid_content_type }
        end

        it 'returns the correct Status code' do
          expect(response.status).to eq 406
        end
      end

      context 'missing json:api media type' do
        let(:headers) do
          {
            'ACCEPT'       => other_accept,
            'CONTENT-TYPE' => valid_content_type,
          }
        end

        it 'returns the correct Status code' do
          expect(response.status).to eq 406
        end
      end

    end

  end

end
