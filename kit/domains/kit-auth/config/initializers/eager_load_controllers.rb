list = [
  'kit/auth/controllers/api_controller',
  'kit/auth/controllers/api/current_user',
  'kit/auth/controllers/api/api_v1_controller',

  'kit/auth/controllers/api/v1/authorization_tokens/create_controller',
  'kit/auth/controllers/api/v1/authorization_tokens/index_controller',
  'kit/auth/controllers/api/v1/authorization_tokens/show_controller',

  'kit/auth/controllers/api/v1/users/create_controller',
  'kit/auth/controllers/api/v1/users/show',

  'kit/auth/controllers/web_controller',

  'kit/auth/controllers/web/current_user',

  #'kit/auth/controllers/web/authorization_tokens/create_controller',
  #'kit/auth/controllers/web/authorization_tokens/destroy_controller',
  #'kit/auth/controllers/web/authorization_tokens/index_controller',

  #'kit/auth/controllers/web/users/reset_password_controller',

  #'kit/auth/controllers/web/users/create_controller',

  'kit/auth/controllers/web/users/reset_password/edit',
  'kit/auth/controllers/web/users/reset_password/update',

  'kit/auth/controllers/web/users/reset_password_request/create',
  'kit/auth/controllers/web/users/reset_password_request/new',
  'kit/auth/controllers/web/users/reset_password_request/process',

  'kit/auth/controllers/web/users/settings/devices/index',

  'kit/auth/controllers/web/users/sign_in/with_password/create',
  'kit/auth/controllers/web/users/sign_in/with_password/new',

  'kit/auth/controllers/web/users/sign_out/destroy',

  'kit/auth/controllers/web/users/sign_up/with_password/create',
  'kit/auth/controllers/web/users/sign_up/with_password/new',

]

autoloader   = Rails.autoloaders.main
default_path = File.expand_path("../../../app/controllers", __FILE__)

list.each do |file|
  autoloader.preload("#{default_path}/#{file}.rb")
end