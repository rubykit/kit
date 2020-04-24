require 'yard'

module Yard
  module Kit

    # Register this gem template path with Yard
    ::YARD::Templates::Engine.register_template_path File.expand_path('../../templates', __dir__)

  end
end

require "yard/kit/contracts_handler"
require "yard/kit/config"
