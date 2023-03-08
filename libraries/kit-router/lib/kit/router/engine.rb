require 'kit/engine'

# Rails engine for `Kit::Router`.
class Kit::Router::Engine < ::Rails::Engine

  Kit::Engine.config_engine(
    context:   self,
    namespace: Kit::Router,
    path:      __dir__,
  )

  initializer 'kit-router.view_helpers' do
    Rails.application.config.to_prepare do
      ActionView::Base.include Kit::Router::ViewHelpers::HttpRoutes
      ActionView::Base.include Kit::Router::ViewHelpers::RouterConn
    end
  end

end
