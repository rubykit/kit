$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "interactor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "interactor"
  spec.version     = Interactor::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-engines.localhost.com"
  spec.summary     = "Summary of Interactor."
  spec.description = "Description of Interactor."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.3"
end
