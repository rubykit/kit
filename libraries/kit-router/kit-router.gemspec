$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/router/version'

version = Kit::Router::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-router'
  s.version     = version
  s.summary     = 'Decouples transport from your controllers.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-router'

  s.metadata = {
    'documentation_uri' => "https://docs.rubykit.org/kit-router/v#{ version }",
    'source_code_uri'   => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-router",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '~> 2.7'

  s.add_dependency             'oj'
  s.add_dependency             'rails', '~> 6.0.3.1'
  s.add_dependency             'tabulo', '~> 2.6'

  s.add_development_dependency 'listen'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'yard'

end
