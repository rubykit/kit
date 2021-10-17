class Kit::Auth::DummyAppContainer::Controllers::WebController < Kit::DummyAppContainer::Controllers::WebController

  layout 'layouts/kit_auth_dummy_application'

  # Adds default route wrapper.
  include Kit::Auth::Controllers::Web::Concerns::DefaultRoute

end
