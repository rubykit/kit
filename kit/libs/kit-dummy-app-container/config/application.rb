require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Kit
  module DummyAppContainer
    class Application < Rails::Application
      Kit::AppContainer.config_application(context: self)
    end
  end
end
