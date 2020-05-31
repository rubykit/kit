=begin
if KIT_APP_PATHS[:ENGINE_ROOT]
  ENGINE_ROOT = KIT_APP_PATHS[:ENGINE_ROOT]
end

if KIT_APP_PATHS[:ENGINE_PATH]
  ENGINE_ROOT = KIT_APP_PATHS[:ENGINE_PATH]
end
=end

require_relative '../../../config/application'
