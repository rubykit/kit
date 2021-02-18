$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/dotenv/version'

version = Kit::Dotenv::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-dotenv'
  s.version     = version
  s.summary     = 'DotEnv config for Kit projects.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-dotenv'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-dotenv",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'dotenv'

end
