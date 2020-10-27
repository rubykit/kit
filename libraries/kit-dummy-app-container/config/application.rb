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

  # REF: https://github.com/rails/rails/blob/master/railties/lib/rails/engine/configuration.rb

  # TODO: replace with Kit::Log
  puts "DEBUG: dummy container app used - GEM_APP: #{ KIT_APP_PATHS['GEM_APP'] }"

  add_to_config_paths = ->(path:, config:, options: {}) do
    return if !path

    list = [path].flatten

    list.each do |path_el|
      config.paths.add path_el, options
    end
  end

  add_to_config_paths.call(config: config, path: KIT_APP_PATHS['GEM_APP'], options: {
    eager_load: true,
    glob:       '{*,*/concerns}',
    exclude:    ['assets'],
  },)

  add_to_config_paths.call(config: config, path: KIT_APP_PATHS['GEM_LIB'], options: { load_path: true })

  add_to_config_paths.call(config: config, path: KIT_APP_PATHS['GEM_SPEC_APP'], options: {
    eager_load: true,
    glob:       '{*,*/concerns}',
    exclude:    ['assets'],
  },)

  add_to_config_paths.call(config: config, path: KIT_APP_PATHS['GEM_SPEC_LIB'], options: { load_path: true })

  #add_to_config_paths.call(config: config, path: KIT_APP_PATHS['GEM_SPEC_VIEWS'])

  if (path = KIT_APP_PATHS['GEM_SPEC_DB'])
    val = config.paths.add path, load_path: true

    ::ActiveRecord::Tasks::DatabaseTasks.db_dir = val.first
  end

  if (path = KIT_APP_PATHS['GEM_ASSETS'])
    [path].flatten.each do |path_el|
      config.assets.paths << path_el
      #config.paths.add path_el, { glob: '*' }
    end
  end

end
