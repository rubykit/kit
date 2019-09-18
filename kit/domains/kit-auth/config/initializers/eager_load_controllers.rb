list = [

  # API ------------------------------------------------------------------------

  'kit/auth/controllers/api',
  'kit/auth/controllers/api/current_user',
  #'kit/auth/controllers/api_controller',
  #'kit/auth/controllers/api/api_v1_controller',

  'kit/auth/controllers/api/v1/authorization_tokens/create',
  'kit/auth/controllers/api/v1/authorization_tokens/index',
  'kit/auth/controllers/api/v1/authorization_tokens/show',

  'kit/auth/controllers/api/v1/users/create',
  'kit/auth/controllers/api/v1/users/show',

  # WEB ------------------------------------------------------------------------

  #'kit/auth/controllers/web_controller',
  'kit/auth/controllers/web/current_user',

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