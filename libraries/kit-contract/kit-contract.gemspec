$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/contract/version'

version = Kit::Contract::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-contract'
  s.version     = version
  s.summary     = 'Validations for all your data.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-contract'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-contract",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'awesome_print'
  s.add_dependency 'concurrent-ruby'
  s.add_dependency 'rails',           '~> 6.0.3.1'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov', '~> 0.17.1'

end