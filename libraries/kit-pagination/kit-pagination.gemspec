$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/pagination/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-pagination"
  spec.version     = Kit::Pagination::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-pagination.localhost.com"
  spec.summary     = "Pagination gem to handle cursor logic"
  spec.description = ""
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_development_dependency 'rspec'

end
