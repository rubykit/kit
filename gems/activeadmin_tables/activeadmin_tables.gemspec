$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "activeadmin_tables/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "activeadmin_tables"
  spec.version     = ActiveadminTables::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-engines.localhost.com"
  spec.summary     = "Summary of ActiveadminTables."
  spec.description = "Description of ActiveadminTables."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.3"
end
