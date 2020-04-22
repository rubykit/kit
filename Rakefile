require 'yard'
require 'yard-kit'

require_relative 'version'

DOC_API_FILES = {
  'kit/libs/kit-json-api' => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
  'kit/libs/kit-organizer' => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
  'kit/libs/kit-pagination' => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
}

#YARD::Templates::Engine.register_template_path '/kit/libs/yard-kit/templates'

# The following static paths and templates are for yard server
#YARD::Server.register_static_path File.dirname(__FILE__) + "/templates/default/fulldoc/html"

YARD::Rake::YardocTask.new do |t|
  t.name = 'yardoc:all'

  files = DOC_API_FILES
    .map do |lib_path, data|
      (data[:include] || []).map { |path| "#{ lib_path }/#{ path }" }
    end
    .flatten

  t.files = files
  t.options = [
    "--output-dir", "docs/api/#{Kit::VERSION::STRING}",
    "--plugin",     "yard-kit",
  ]
end
