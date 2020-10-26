require_relative 'boot'

require 'rails/all'

if KIT_APP_PATHS['GEM_RAILTIE']
  require KIT_APP_PATHS['GEM_RAILTIE']
end

Bundler.require(*Rails.groups)

module Kit # rubocop:disable Style/Documentation
end

module Kit::DummyAppContainer # rubocop:disable Style/Documentation
end

class Kit::DummyAppContainer::Application < ::Rails::Application # rubocop:disable Style/Documentation

  Kit::AppContainer.config_application(context: self)

  # TODO: replace with Kit::Log
  puts "DEBUG: dummy container app used - GEM_APP: #{ KIT_APP_PATHS['GEM_APP'] }"

  if KIT_APP_PATHS['GEM_APP']
    config.paths.add KIT_APP_PATHS['GEM_APP'], {
      eager_load: true,
      glob:       '{*,*/concerns}',
      exclude:    ['assets'],
    }
  end

  if KIT_APP_PATHS['GEM_LIB']
    config.paths.add KIT_APP_PATHS['GEM_LIB'], load_path: true
  end

  if KIT_APP_PATHS['GEM_SPEC_APP']
    config.paths.add KIT_APP_PATHS['GEM_SPEC_APP'], {
      eager_load: true,
      glob:       '{*,*/concerns}',
      exclude:    ['assets'],
    }
  end

  if KIT_APP_PATHS['GEM_SPEC_LIB']
    config.paths.add KIT_APP_PATHS['GEM_SPEC_LIB'], load_path: true
  end

  if KIT_APP_PATHS['GEM_SPEC_DB']
    val = config.paths.add KIT_APP_PATHS['GEM_SPEC_DB'], load_path: true

    ::ActiveRecord::Tasks::DatabaseTasks.db_dir = val.first
  end

end
