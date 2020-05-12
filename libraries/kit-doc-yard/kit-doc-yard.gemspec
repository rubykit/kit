$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/doc/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-doc-yard"
  spec.version     = Kit::Doc::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan@rubykit.org"]
  spec.homepage    = "https://github.com/rubykit/kit/tree/master/libraries/kit-doc-yard"
  spec.summary     = "Yard setup & plugins for Kit"
  spec.description = "Kit::Doc::Yard is a Yard plugin that generates ExDoc look-alike documentation."
  spec.license     = "MIT"

  spec.files       = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  # @todo All of these should be development dependencies, but that prevent them from being added to to projects using the gem.
  spec.add_dependency 'git'
  spec.add_dependency 'rake'
  spec.add_dependency 'redcarpet'
  spec.add_dependency 'rspec'
  spec.add_dependency 'yard'
  spec.add_dependency 'nokogiri'

end
