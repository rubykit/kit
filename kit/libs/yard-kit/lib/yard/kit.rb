require 'yard'

module Yard
  module Kit

    # Register this gem template path with Yard
    ::YARD::Templates::Engine.register_template_path File.expand_path('../../templates', __dir__)

  end
end

require 'yard/kit/contracts_handler'
require 'yard/kit/config'

require 'yard/kit/redcarpet/redcarpet_render_custom.rb'
require 'yard/kit/redcarpet/redcarpet_compat.rb'

require 'yard/kit/yard/templates/helpers/yard_kit_plugin_helper'
require 'yard/kit/yard/overrides/html_helper'
require 'yard/kit/yard/overrides/base'
require 'yard/kit/yard/overrides/extra_file_object'

require 'yard/kit/services'
