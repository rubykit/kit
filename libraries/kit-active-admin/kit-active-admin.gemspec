$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/active_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-active-admin"
  spec.version     = Kit::ActiveAdmin::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-active-admin.localhost.com"
  spec.summary     = "Summary of Kit::ActiveAdmin."
  spec.description = "Description of Kit::ActiveAdmin."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "activeadmin", "~> 2.2"
  spec.add_dependency "activeadmin_addons", "~> 1.7", ">= 1.7.1"

  spec.add_dependency "popper_js"
  spec.add_dependency "bootstrap", "~> 4.0"

end
