autoloader   = Rails.autoloaders.main

autoloader.on_setup { Kit::Auth::DummyAppContainer::Controllers::WebController }
autoloader.on_setup { Kit::Auth::DummyAppContainer::Controllers::Web::ExampleController }
