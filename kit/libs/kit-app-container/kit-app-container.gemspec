$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/app_container/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-app-container"
  spec.version     = Kit::AppContainer::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-app-container.localhost.com"
  spec.summary     = "Summary of Kit::AppContainer"
  spec.description = "Description of Kit::AppContainer"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails_event_store"

  spec.add_dependency "sidekiq"

  spec.add_dependency "activerecord-nulldb-adapter"

end
