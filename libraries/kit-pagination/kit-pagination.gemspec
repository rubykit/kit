$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/pagination/version'

version = Kit::Pagination::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-pagination'
  s.version     = version
  s.summary     = 'Set pagination.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-pagination'

  s.metadata = {
    'documentation_uri' => "https://docs.rubykit.org/kit-pagination/v#{ version }",
    'source_code_uri'   => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-pagination",
  }

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov', '~> 0.17.1'

end
