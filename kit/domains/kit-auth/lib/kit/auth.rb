require "doorkeeper"

module Kit
  module Auth
    Doorkeeper = ::Doorkeeper

  end
end

require "kit/auth/engine"
require "kit/auth/routes"

# DEV
require_relative "error"
