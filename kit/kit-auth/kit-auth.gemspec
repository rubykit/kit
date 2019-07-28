$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-auth"
  spec.version     = Kit::Auth::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-engines.localhost.com"
  spec.summary     = "Summary of Kit::Auth."
  spec.description = "Description of Kit::Auth."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "doorkeeper", "~> 5.1"
  spec.add_dependency "omniauth", "~> 1.6", ">= 1.6.1"
  spec.add_dependency "oauth2", "~> 1.4", ">= 1.4.1"

  spec.add_dependency "strong_password", "~> 0.0.8"
  spec.add_dependency "email_inquire", "~> 0.10.0"

  spec.add_dependency "bcrypt"

end
