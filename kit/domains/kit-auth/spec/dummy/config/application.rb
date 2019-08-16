require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "kit/auth"

module Dummy
  class Application < Rails::Application
    Kit::AppContainer.config_application(context: self)
  end
end

