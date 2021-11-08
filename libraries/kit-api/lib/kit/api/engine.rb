# Rails engine for dev & test mode.
#
# Handles file loading && initializers.
class Kit::Api::Engine < ::Rails::Engine

  initializer 'kit-api.jsonapi_mime_types' do
    media_type = 'application/vnd.api+json'.freeze

    Mime::Type.register(media_type, :json_api)

    parser = ->(body) { Oj.safe_load(body) }

    # NOTE: `ActionDispatch::IntegrationTest.register_encoder` does not seem to work
    ActionDispatch::Request.parameter_parsers[:json_api] = parser
  end

end
