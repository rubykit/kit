autoloader = Rails.autoloaders.main

autoloader.on_setup { Kit::DummyAppContainer::Controllers::Web::HomeController }
