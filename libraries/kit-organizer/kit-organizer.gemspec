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
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-organizer'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-organizer",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'awesome_print'
  s.add_dependency 'concurrent-ruby'
  s.add_dependency 'rails',           '~> 6.0.3.1'

  s.add_development_dependency 'rspec-rails'

end
