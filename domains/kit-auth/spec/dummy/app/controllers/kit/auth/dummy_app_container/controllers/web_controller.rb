class Kit::Auth::DummyAppContainer::Controllers::WebController < Kit::DummyAppContainer::Controllers::WebController

  # Adds default route wrapper.
  include Kit::Auth::Controllers::Web::Concerns::DefaultRoute

end
