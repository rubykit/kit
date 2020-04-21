$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/organizer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-organizer"
  spec.version     = Kit::Organizer::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-organizer.localhost.com"
  spec.summary     = "Organizer gem to allow railway programming in ruby"
  spec.description = ""
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0"
  spec.add_dependency "awesome_print"

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'listen'
end
