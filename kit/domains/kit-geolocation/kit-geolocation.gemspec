$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/geolocation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-geolocation"
  spec.version     = Kit::Geolocation::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-geolocation.localhost.com"
  spec.summary     = "Summary of Kit::Geolocation."
  spec.description = "Description of Kit::Geolocation."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

end
