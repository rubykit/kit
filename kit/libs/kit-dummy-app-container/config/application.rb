require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Kit
  module DummyAppContainer
    class Application < Rails::Application
      Kit::AppContainer.config_application(context: self)

      if KIT_APP_PATHS['GEM_APP']
        config.paths.add KIT_APP_PATHS['GEM_APP'], {
          eager_load: true,
          glob:       "{*,*/concerns}",
          exclude:    ["assets"],
        }
      end

      if KIT_APP_PATHS['GEM_LIB']
        config.paths.add KIT_APP_PATHS['GEM_LIB'], load_path: true
      end

    end
  end
end
