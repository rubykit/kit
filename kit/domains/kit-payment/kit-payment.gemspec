$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kit/payment/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kit-payment"
  spec.version     = Kit::Payment::VERSION
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://ruby-kit-payment.localhost.com"
  spec.summary     = "Summary of Kit::Payment."
  spec.description = "Description of Kit::Payment."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

end
