$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/api/version'

version = Kit::Api::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-api'
  s.version     = version
  s.summary     = 'An extensive JSON:API server implementation.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/main/libraries/kit-api'

  s.metadata = {
    'documentation_uri' => "https://docs.rubykit.org/kit-api/v#{ version }",
    'source_code_uri'   => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-api",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'oj',       '~> 3.3', '>= 3.3.5'
  s.add_dependency 'rails',    '~> 6.0'
  s.add_dependency 'urlcrypt', '~> 0.1.1'

  #s.add_development_dependency 'json_schemer'
  #s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov', '~> 0.17.1'
  s.add_development_dependency 'yard'

end
