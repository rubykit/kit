$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/geolocation/version'

version = Kit::Geolocation::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-geolocation'
  s.version     = version
  s.summary     = 'Static & dynamic ip based geolocation.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/main/domains/kit-geolocation'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/domains/kit-geolocation",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

end
