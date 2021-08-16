$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/dummy-app-container/version'

version = Kit::DummyAppContainer::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-dummy-app-container'
  s.version     = version
  s.summary     = 'Dummy Rails app for specs.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-dummy-app-container'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-dummy-app-container",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'rails', '~> 6.1'

  s.add_dependency 'sidekiq'

  #s.add_development_dependency 'listen'
  s.add_development_dependency 'rubocop'

end
