list = [
  'app/controllers/kit/dummy_app_container/controllers/web/home_controller',
]

autoloader   = Rails.autoloaders.main
default_path = File.expand_path('../..', __dir__)

list.each do |file|
  autoloader.preload("#{ default_path }/#{ file }.rb")
end
