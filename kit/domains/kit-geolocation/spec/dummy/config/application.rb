require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "kit/geolocation"

module Dummy
  class Application < Rails::Application
    Kit::AppContainer.config_application(context: self)
  end
end

