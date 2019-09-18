list = [
  'app/controllers/web/home_controller',
]

autoloader   = Rails.autoloaders.main
default_path = File.expand_path("../../../", __FILE__)

list.each do |file|
  autoloader.preload("#{default_path}/#{file}.rb")
end