$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/rspec_formatter/version'

version = Kit::RspecFormatter::VERSION

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'kit-rspec-formatter'
  s.version     = version
  s.authors     = ['Nathan Appere']
  s.email       = ['nathan@rubykit.org']
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-rspec-formatter'
  s.summary     = 'Rspec formatter'
  s.description = 'Kit::RspecFormatter is the RSPEC formatter used in tghe Kit project.'
  s.license     = 'MIT'

  s.metadata = {
    'documentation_uri' => "https://docs.rubykit.org/kit-rspec-formatter/v#{ version }",
    'source_code_uri'   => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-rspec-formatter",
  }

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE.md', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'

end
