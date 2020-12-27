$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/log/version'

version = Kit::Log::VERSION

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'kit-log'
  s.version     = version
  s.authors     = ['Nathan Appere']
  s.email       = ['nathan@rubykit.org']
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-log'
  s.summary     = 'Rspec formatter'
  s.description = 'Kit::Log is the RSPEC formatter used in tghe Kit project.'
  s.license     = 'MIT'

  s.metadata = {
    'documentation_uri' => "https://docs.rubykit.org/kit-log/v#{ version }",
    'source_code_uri'   => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-log",
  }

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE.md', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 2.7'

  s.add_development_dependency 'rubocop'

end
