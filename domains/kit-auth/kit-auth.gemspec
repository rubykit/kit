$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/auth/version'

version = Kit::Auth::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-auth'
  s.version     = version
  s.summary     = 'Authentication & authorization out of the box.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/main/domains/kit-auth'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/domains/kit-auth",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'bcrypt'
  s.add_dependency 'browser'
  s.add_dependency 'doorkeeper',                     '~> 5.4.0'
  s.add_dependency 'email_inquire',                  '~> 0.10.0'
  s.add_dependency 'jsonb_accessor',                 '>= 1.3.7'
  s.add_dependency 'lockbox'
  s.add_dependency 'oauth2',                         '~> 1.4.4'
  s.add_dependency 'omniauth',                       '~> 1.9.1'
  s.add_dependency 'omniauth-rails_csrf_protection', '~> 0.1.2'
  s.add_dependency 'strong_password',                '~> 0.0.8'

  s.add_dependency 'sass-rails'

  s.add_dependency 'seedbank'

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov', '~> 0.17.1'

end
