$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/error/version'

version = Kit::Error::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-error'
  s.version     = version
  s.summary     = 'Generic error handling logic for Kit.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/main/libraries/kit-error'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-error",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'

end
