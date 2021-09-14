autoloader   = Rails.autoloaders.main
default_path = File.expand_path('../../app/endpoints', __dir__)

Dir["#{ default_path }/**/*.rb"].each do |file|
  autoloader.preload(file)
end
