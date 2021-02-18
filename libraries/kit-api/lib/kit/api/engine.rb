# Rails engine for dev & test mode.
#
# Handles file loading && initializers.
class Kit::Api::Engine < ::Rails::Engine

  dir = __dir__

  initializer 'kit-api.spec_append_migrations' do |app|
    app.config.paths['db/migrate'] << File.expand_path('../../../spec/dummy/db/migrate', dir)
  end

  initializer 'kit-api.jsonapi_mime_types' do
    media_type = 'application/vnd.api+json'.freeze

    Mime::Type.register(media_type, :json_api)

    parser = ->(body) { Oj.safe_load(body) }

    # NOTE: `ActionDispatch::IntegrationTest.register_encoder` does not seem to work
    ActionDispatch::Request.parameter_parsers[:json_api] = parser
  end

end
