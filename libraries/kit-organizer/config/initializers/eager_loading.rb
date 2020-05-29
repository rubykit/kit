list = [
  'app/services/kit/organizer',
]

autoloader   = Rails.autoloaders.main
default_path = File.expand_path('../..', __dir__)

list.each do |file|
  autoloader.preload("#{ default_path }/#{ file }.rb")
end
