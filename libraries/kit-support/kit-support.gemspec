$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/support/version'

version = Kit::Support::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-support'
  s.version     = version
  s.summary     = 'A toolkit of support libraries and Ruby core extensions.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-support'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-support",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_development_dependency 'rubocop'

end
