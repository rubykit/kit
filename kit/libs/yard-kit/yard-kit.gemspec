$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "yard/kit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "yard-kit"
  spec.version     = Yard::Kit::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-yard-kit.localhost.com"
  spec.summary     = "Yard setup & plugins for Kit"
  spec.description = ""
  spec.license     = "MIT"

  spec.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'

  spec.add_development_dependency 'rspec'

end
