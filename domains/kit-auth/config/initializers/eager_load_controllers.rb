list = [

  # WEB ------------------------------------------------------------------------

  #'kit/auth/controllers/web/web_controller',
  'kit/auth/controllers/web/current_user',
]

autoloader   = Rails.autoloaders.main
default_path = File.expand_path('../../app/controllers', __dir__)

list.each do |file|
  autoloader.preload("#{ default_path }/#{ file }.rb")
end

=begin
autoloader   = Rails.autoloaders.main
default_path = File.expand_path('../../app/controllers', __dir__)

Dir["#{ default_path }/**/*.rb"].each do |file|
  autoloader.preload(file)
end
=end
