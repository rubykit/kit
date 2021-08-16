$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/app_container/version'

version = Kit::AppContainer::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-app-container'
  s.version     = version
  s.summary     = 'Expose your domains to the world or each-other.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-app-container'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-app-container",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_development_dependency 'rubocop'

end
