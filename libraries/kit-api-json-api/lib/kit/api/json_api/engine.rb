class Kit::Api::JsonApi::Engine < ::Rails::Engine

  file = __FILE__

  initializer :spec_append_migrations do |app|
    app.config.paths['db/migrate'] << File.expand_path('../../../../../spec/dummy/db/migrate', file)
  end

end
