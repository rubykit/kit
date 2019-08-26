require 'kit/domain'
require_relative 'view_helpers'

module Kit::Router
  class Engine < ::Rails::Engine

    Kit::Domain.config_engine(
      context:   self,
      namespace: Kit::Router,
      file:      __FILE__,
    )

    initializer "kit-router.view_helpers" do
      ActionView::Base.send :include, Kit::Router::ViewHelpers
    end

  end
end
