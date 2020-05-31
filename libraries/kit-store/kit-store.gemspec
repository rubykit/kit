$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/store/version'

version = Kit::Store::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-store'
  s.version     = version
  s.summary     = 'In-memory database. Brings Microsoft LINQ features to Ruby.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-store'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-store",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency             'rails', '~> 6.0.3.1'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'

end
