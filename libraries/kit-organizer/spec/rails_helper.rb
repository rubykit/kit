ENV['RAILS_ENV'] ||= 'test'

ENV['DATABASE_ADAPTER'] = 'nulldb'
# NOTE: somehow having a DATABASE_URL in the config env of `dummy-app-container` bypasses the `nulldb` adapter.
#  `primary` gets registered as `nulldb` a first time, then a second as `postgres`
ENV['DATABASE_URL']     = nil
ENV['EVENT_STORE']      = 'false'

KIT_APP_PATHS ||= {}
KIT_APP_PATHS['GEM_ROOT'] = File.expand_path('..', __dir__)
KIT_APP_PATHS['GEM_APP']  = File.expand_path('../app', __dir__)
KIT_APP_PATHS['GEM_LIB']  = File.expand_path('../lib', __dir__)
KIT_APP_PATHS['GEMFILE']  = File.expand_path('../Gemfile', __dir__)

# Simplecov
if ENV['SIMPLECOV'] == 'true'
  require 'simplecov'
  SimpleCov.start
end

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= KIT_APP_PATHS['GEMFILE']
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

require 'kit/dummy-app-container/rails_rspec'

require_relative 'spec_helper'

Dir[Rails.root.join('../support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
