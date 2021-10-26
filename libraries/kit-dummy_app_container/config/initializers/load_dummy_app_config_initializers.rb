# Load the initializers from the dummy app.
#
# Note: way easier to do it here than playing with Rails::Engine::Configuration.paths like we do in this gem `application.rb`

path = File.expand_path('config/initializers', KIT_APP_PATHS['GEM_SPEC_ROOT'])

Dir["#{ path }/**/*.rb"].each do |file|
  ActiveSupport::Notifications.instrument('load_config_initializer.railties', initializer: file) do
    load(file)
  end
end
