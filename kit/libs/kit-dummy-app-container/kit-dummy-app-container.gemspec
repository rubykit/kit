$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/dummy-app-container/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-dummy-app-container"
  spec.version     = Kit::DummyAppContainer::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-dummy-app-container.localhost.com"
  spec.summary     = "Summary of Kit::DummyAppContainer."
  spec.description = "Description of Kit::DummyAppContainer."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails"

end
