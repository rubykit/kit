# Namespace for Yard specific logic.
module Kit::Doc::Yard
end

require_relative 'yard/custom_tags'
require_relative 'yard/handlers/kit_doc_contracts_handler'
require_relative 'yard/templates/template_plugin_helper'
require_relative 'yard/file_serializer'
require_relative 'yard/overrides/html_helper'
require_relative 'yard/overrides/base'
require_relative 'yard/overrides/extra_file_object'
require_relative 'yard/overrides/logging'
require_relative 'yard/overrides/yardoc'
