# On initialization
autoloader   = Rails.autoloaders.main
default_path = File.expand_path('../../app/endpoints', __dir__)

Dir["#{ default_path }/**/*.rb"].each do |file|
  autoloader.preload(file)
end

# When autoreloading in development mode.
Rails.application.reloader.after_class_unload do
  default_path = File.expand_path('../../app/endpoints', __dir__)
  Dir["#{ default_path }/**/*.rb"].each do |file|
    load(file)
  end
end
