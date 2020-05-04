require 'yard'

module Kit
  module Doc

    # Register this gem template path with Yard
    ::YARD::Templates::Engine.register_template_path File.expand_path('../../templates', __dir__)

  end
end

#require 'kit/doc/config'
require 'kit/doc/redcarpet'
require 'kit/doc/yard'
require 'kit/doc/services'
