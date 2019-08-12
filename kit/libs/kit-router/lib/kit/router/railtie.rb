require_relative 'view_helpers'

module Kit::Router
  class Railtie < ::Rails::Railtie

    initializer "kit-router.view_helpers" do
      ActionView::Base.send :include, Kit::Router::ViewHelpers
      Cell::ViewModel.send  :include, Kit::Router::ViewHelpers
    end

  end
end
