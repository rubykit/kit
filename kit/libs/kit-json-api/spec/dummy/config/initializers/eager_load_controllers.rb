list = [
  'api_controller',
  'kit/json_api_specs/controllers/users/index',
]

autoloader   = Rails.autoloaders.main
default_path = File.expand_path("../../../app/controllers", __FILE__)

list.each do |file|
  autoloader.preload("#{default_path}/#{file}.rb")
end
