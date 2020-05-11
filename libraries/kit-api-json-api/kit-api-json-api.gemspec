$:.push File.expand_path("lib", __dir__)
require "kit/api/json_api/version"

Gem::Specification.new "kit-api-json-api", Kit::Api::JsonApi::VERSION do |spec|
  spec.authors     = ["Nathan Appere"]
  spec.email       = ["nathan.appere@gmail.com"]
  spec.homepage    = "https://github.com/rubykit/kit/tree/master/libraries/kit-api-json-api"
  spec.description = spec.summary = "JSON API server implementation."
  spec.license     = "MIT"

  spec.files       = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0"

  spec.add_dependency "oj", "~> 3.3", ">= 3.3.5"

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'listen'

  spec.add_development_dependency 'yard'

end
