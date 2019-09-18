$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/router/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-router"
  spec.version     = Kit::Router::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-router.localhost.com"
  spec.summary     = "Router gem to handle path overrides between engines"
  spec.description = ""
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0"

  spec.add_dependency "dry-types"

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'listen'
end
