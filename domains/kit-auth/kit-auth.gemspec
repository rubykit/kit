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
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/domains/kit-auth'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/domains/kit-auth",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'bcrypt'
  s.add_dependency 'browser'
  s.add_dependency 'doorkeeper',      '~> 5.2.0.rc2'
  s.add_dependency 'email_inquire',   '~> 0.10.0'
  s.add_dependency 'oauth2',          '~> 1.4.1'
  s.add_dependency 'omniauth',        '~> 1.6.1'
  s.add_dependency 'strong_password', '~> 0.0.8'

end
