# frozen_string_literal: true

version = File.read(File.expand_path('KIT_VERSION', __dir__)).strip

Gem::Specification.new do |s|
  s.name        = 'kit'
  s.version     = version
  s.summary     = 'Full-stack web application framework.'
  s.description = ''
  s.license     = 'MIT'
  s.author      = 'Nathan Appere'
  s.email       = 'nathan@rubykit.org'
  s.homepage    = 'https://rubykit.org'

  s.metadata = {
    'documentation_uri' => "https://docs.rubykit.org/v#{ version }",
    'source_code_uri'   => "https://github.com/rubykit/kit/tree/v#{ version }",
  }

  s.files = ['README.md']

  s.required_ruby_version     = '>= 2.7.0'
  s.required_rubygems_version = '>= 3.1.0'

  # TODO: add various RubyKit Gems when we start releasing them.

  s.add_development_dependency 'git'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'yard'

end
