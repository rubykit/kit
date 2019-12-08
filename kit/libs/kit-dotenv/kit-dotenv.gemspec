$:.push File.expand_path("lib", __dir__)
require "kit/dotenv/version"

Gem::Specification.new "kit-dotenv", Kit::Dotenv::VERSION do |gem|
  gem.authors     = ["Nathan Appere"]
  gem.email       = ["nathan.appere@gmail.com"]
  gem.homepage    = "https://ruby-kit-dotenv.localhost.com"
  gem.description = gem.summary = "DotEnv config for Kit projects"
  gem.license     = "MIT"

  gem.files       = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  gem.add_dependency "dotenv"

end
