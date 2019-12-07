$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/json_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-json-api"
  spec.version     = Kit::JsonApi::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-json-api.localhost.com"
  spec.summary     = "JSON API server implementation."
  spec.description = ""
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0"

  spec.add_dependency "oj", "~> 3.3", ">= 3.3.5"

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'listen'

  spec.add_development_dependency 'yard'

end
