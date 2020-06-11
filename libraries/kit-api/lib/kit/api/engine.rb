# Rails engine for dev & test mode.
#
# Handles file loading && initializers.
class Kit::Api::Engine < ::Rails::Engine

  dir = __dir__

  initializer :spec_append_migrations do |app|
    app.config.paths['db/migrate'] << File.expand_path('../../../spec/dummy/db/migrate', dir)
  end

end