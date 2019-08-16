$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/domain/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-domain"
  spec.version     = Kit::Domain::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-domains.localhost.com"
  spec.summary     = "Hold shared logic for all Kit Domains"
  spec.description = ""
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.0.rc2"

  spec.add_dependency "slim-rails"

  spec.add_dependency "multiverse", "~> 0.2.1"

  spec.add_dependency "pg", "~> 1.1", ">= 1.1.4"
  spec.add_dependency "activerecord-nulldb-adapter", "~> 0.3.9"
  spec.add_dependency "paranoia", "~> 2.4", ">= 2.4.1"

  spec.add_dependency "dotenv-rails", "~> 2.1", ">= 2.1.1"

  spec.add_dependency "interactor"
  spec.add_dependency "rubocop", "~> 0.42.0"

  spec.add_dependency "contracts", "~> 0.16.0"
  spec.add_dependency "dry-validation"
  spec.add_dependency "dry-struct"

  spec.add_dependency "rails_event_store"

  spec.add_dependency "jsonapi-rails"

  spec.add_dependency "seedbank"

  spec.add_development_dependency "annotate"

  #spec.add_dependency 'paranoia'

end
