$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/active_admin/version'

version = Kit::ActiveAdmin::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-active-admin'
  s.version     = version
  s.summary     = 'ActiveAdmin wrapper for Kit projects.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-active-admin'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-active-admin",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'activeadmin',        '~> 2.9.0'
  s.add_dependency 'activeadmin_addons', '~> 1.7.1'
  s.add_dependency 'bootstrap',          '~> 4.5.3'
  s.add_dependency 'popper_js',          '~> 1.16'

end
