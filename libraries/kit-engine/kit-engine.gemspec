$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/engine/version'

version = Kit::Engine::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-engine'
  s.version     = version
  s.summary     = 'Shared logic for engines.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-engine'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-engine",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'activerecord-nulldb-adapter'
  s.add_dependency 'rails',                       '~> 6.1.0'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'

end
