RSpec.shared_context 'json:api' do

  let(:jsonapi_media_type) { Kit::Api::JsonApi::Services::Endpoints::Guards::JSONAPI_MEDIA_TYPE }

  # References:
  # - https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept
  # - https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type
  let(:jsonapi_headers) do
    {
      'ACCEPT'       => jsonapi_media_type,
      'CONTENT-TYPE' => "#{ jsonapi_media_type };",
    }
  end

  let(:jsonapi_response_body) do
    JSON.parse(response.body, symbolize_names: true)
  end

  shared_examples 'a valid json:api response' do
    it 'validates against json:api json-schema' do
      status, = Kit::Api::JsonApi::Services::SchemaValidation.valid?(data: jsonapi_response_body)
      expect(status).to eq :ok
    end
  end

end
