$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'kit/doc/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'kit-doc'
  s.version     = Kit::Doc::VERSION
  s.authors     = ['Nathan Appere']
  s.email       = ['nathan@rubykit.org']
  s.homepage    = 'https://github.com/rubykit/kit/tree/master/libraries/kit-doc'
  s.summary     = 'Yard setup & plugins for Kit'
  s.description = 'Kit::Doc is a Yard plugin that generates ExDoc look-alike documentation.'
  s.license     = 'MIT'

  s.files       = Dir['{lib,tasks}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  # @todo All of these should be development dependencies, but that prevent them from being added to to projects using the gem.
  s.add_dependency 'git'
  s.add_dependency 'nokogiri'
  s.add_dependency 'rails'
  s.add_dependency 'rake'
  s.add_dependency 'redcarpet'
  s.add_dependency 'rspec'
  s.add_dependency 'yard'

  s.add_development_dependency 'rubocop'

end
