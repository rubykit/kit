$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/error/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-error"
  spec.version     = Kit::Error::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-error.localhost.com"
  spec.summary     = "Error gem to handle error logic"
  spec.description = ""
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_development_dependency 'rspec'

end
