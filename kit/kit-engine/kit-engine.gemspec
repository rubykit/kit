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

  spec.add_dependency "rails", "~> 5.2.3"

  spec.add_dependency "slim-rails"
  spec.add_dependency "simple_form"
  spec.add_dependency "cells-slim"

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

  spec.add_dependency "fast_jsonapi", "~> 1.5"

  spec.add_dependency "activeadmin", "~> 2.2"
  spec.add_dependency "activeadmin_addons", "~> 1.7", ">= 1.7.1"
  spec.add_dependency "activeadmin_tables"

  #spec.add_dependency "cells", "~> 4.1", ">= 4.1.7"

  spec.add_development_dependency "annotate"

  #spec.add_dependency 'paranoia'

end
