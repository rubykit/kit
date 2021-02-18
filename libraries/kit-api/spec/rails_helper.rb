ENV['RAILS_ENV'] ||= 'test'

ENV['EVENT_STORE'] = 'false'

require_relative '../config/kit_runtime_config'

# Simplecov
if ENV['SIMPLECOV'] == 'true'
  require 'simplecov'
  SimpleCov.start
end

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= KIT_APP_PATHS['GEMFILE']
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

require 'kit/dummy-app-container/rails_rspec'

require 'spec_helper'

Dir[Rails.root.join('../support/**/*.rb')].each { |f| require f }
Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require f }

require_relative 'dummy/config/initializers/api_config'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
