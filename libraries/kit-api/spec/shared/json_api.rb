RSpec.shared_context 'json:api' do

  let(:jsonapi_media_type) { Kit::Api::JsonApi::Controllers::JsonApi::JSONAPI_MEDIA_TYPE }

  # References:
  # - https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept
  # - https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type
  let(:jsonapi_headers) do
    {
      'ACCEPT'       => jsonapi_media_type,
      'CONTENT-TYPE' => "#{ jsonapi_media_type };",
    }
  end

end
