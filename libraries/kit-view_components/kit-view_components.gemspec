$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'kit/view_components/version'

version = Kit::ViewComponents::VERSION

Gem::Specification.new do |s|
  s.name        = 'kit-view_components'
  s.version     = version
  s.summary     = 'Collection of UI view components used in Kit.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://github.com/rubykit/kit/tree/main/libraries/kit-view_components'

  s.metadata = {
    'source_code_base_uri' => 'https://github.com/rubykit/kit',
    'source_code_uri'      => "https://github.com/rubykit/kit/tree/v#{ version }/libraries/kit-view_components",
    'documentation_uri'    => "https://docs.rubykit.org/v#{ version }",
  }

  s.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 3.0'

  s.add_dependency 'slim-rails'
  s.add_dependency 'view_component', '>= 2.40.0'

  s.add_development_dependency 'rubocop'

end
