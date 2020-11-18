list = [
  'api_controller',
  'kit/json_api_spec/controllers/create',
  'kit/json_api_spec/controllers/delete',
  'kit/json_api_spec/controllers/read',
  'kit/json_api_spec/controllers/update',
]

autoloader   = Rails.autoloaders.main
default_path = File.expand_path('../../app/controllers', __dir__)

list.each do |file|
  autoloader.preload("#{ default_path }/#{ file }.rb")
end
