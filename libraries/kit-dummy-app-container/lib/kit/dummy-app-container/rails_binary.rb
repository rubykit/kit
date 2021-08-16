if KIT_APP_PATHS[:ENGINE_ROOT]
  ENGINE_ROOT = KIT_APP_PATHS[:ENGINE_ROOT]
end

if KIT_APP_PATHS[:ENGINE_PATH]
  ENGINE_ROOT = KIT_APP_PATHS[:ENGINE_PATH]
end

APP_PATH = File.expand_path('../../../config/application', __dir__)

require 'rails'

rails_dependencies = KIT_APP_PATHS['RAILS_DEPENDENCIES'] || %w[
  active_record/railtie
  active_storage/engine
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  action_mailbox/engine
  action_text/engine
  rails/test_unit/railtie
  sprockets/railtie
]

rails_dependencies.each do |railtie|
  require railtie
rescue LoadError => e
  puts "Rails dependencies error: could not load #{ e }"
end

require 'rails/engine/commands'
