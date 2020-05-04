if KIT_APP_PATHS[:ENGINE_ROOT]
  ENGINE_ROOT = KIT_APP_PATHS[:ENGINE_ROOT]
end

if KIT_APP_PATHS[:ENGINE_PATH]
  ENGINE_ROOT = KIT_APP_PATHS[:ENGINE_PATH]
end

APP_PATH = File.expand_path('../../../config/application', __dir__)

require 'rails/all'
require 'rails/engine/commands'
