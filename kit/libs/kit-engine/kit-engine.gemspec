$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-engine"
  spec.version     = Kit::Engine::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-engines.localhost.com"
  spec.summary     = "Hold shared logic for all Kit Engines"
  spec.description = ""
  spec.license     = "MIT"


  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails"

  spec.add_dependency "activerecord-nulldb-adapter"

end
