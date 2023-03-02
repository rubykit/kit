$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/organizer/version'

version = Kit::Organizer::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-organizer'
  s.version     = version
  s.summary     = 'Handles code flow.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/main/libraries/kit-organizer'

  s.metadata = {
    'documentation_uri' => "https://docs.rubykit.org/kit-organizer/v#{ version }",
    'source_code_uri'   => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-organizer",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'awesome_print'
  #s.add_dependency 'rails',           '>= 6.1'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov', '~> 0.17.1'

end
