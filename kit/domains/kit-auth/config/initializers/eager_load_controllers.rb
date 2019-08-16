list = [
  'kit/auth/controllers/api_controller',
  'kit/auth/controllers/api/api_v1_controller',

  'kit/auth/controllers/api/v1/authorization_tokens/create_controller',
  'kit/auth/controllers/api/v1/authorization_tokens/index_controller',
  'kit/auth/controllers/api/v1/authorization_tokens/show_controller',

  'kit/auth/controllers/api/v1/users/create_controller',
  'kit/auth/controllers/api/v1/users/show_controller',

  'kit/auth/controllers/web_controller',

  'kit/auth/controllers/web/authorization_tokens/create_controller',
  'kit/auth/controllers/web/authorization_tokens/destroy_controller',
  'kit/auth/controllers/web/authorization_tokens/index_controller',

  'kit/auth/controllers/web/users/create_controller',
]

autoloader   = Rails.autoloaders.main
default_path = File.expand_path("../../../app/controllers", __FILE__)

list.each do |file|
  autoloader.preload("#{default_path}/#{file}.rb")
end