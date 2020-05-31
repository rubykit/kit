require 'kit/engine'

# Rails engine for `Kit::Router`.
class Kit::Router::Engine < ::Rails::Engine

  Kit::Engine.config_engine(
    context:   self,
    namespace: Kit::Router,
    file:      __FILE__,
  )

  initializer 'kit-router.view_helpers' do
    ActionView::Base.include Kit::Router::ViewHelpers::HttpRoutes
  end

  # TODO: move this to an kit-api gem ?
  initializer 'kit-router.mime_types' do
    media_type = 'application/vnd.api+json'.freeze
    Mime::Type.register(media_type, :jsonapi)
    Mime::Type.register(media_type, :json_api)
  end

end
