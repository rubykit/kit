require 'yard'

module Kit # rubocop:disable Style/Documentation
end

module Kit::Doc # rubocop:disable Style/Documentation

  # Register this gem template path with Yard
  ::YARD::Templates::Engine.register_template_path File.expand_path('../../templates', __dir__)

end

#require 'kit/doc/config'
require 'kit/doc/redcarpet'
require 'kit/doc/yard'
require 'kit/doc/services'
require 'kit/doc/railtie'
