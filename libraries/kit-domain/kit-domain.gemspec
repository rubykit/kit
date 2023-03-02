$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/domain/version'

version = Kit::Domain::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-domain'
  s.version     = version
  s.summary     = 'Hold shared logic for all Kit Domains.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/main/libraries/kit-domain'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-domain",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'activerecord-nulldb-adapter', '>= 0.4.0'
  s.add_dependency 'multiverse',                  '>= 0.2.1'
  s.add_dependency 'paranoia',                    '>= 2.4', '>= 2.4.3'
  s.add_dependency 'pg',                          '>= 1.2.3'

  s.add_dependency 'rails',                       '>= 6.1'
  s.add_dependency 'slim-rails'

  s.add_dependency 'i18n-interpolate_nested'

  s.add_dependency 'activeadmin', '~> 2.9.0'

  s.add_development_dependency 'annotate'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'seedbank'

end
