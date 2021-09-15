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
    ActionView::Base.include Kit::Router::ViewHelpers::RouterConn
  end

end
