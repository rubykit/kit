# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
#require File.expand_path('../../config/environment', __FILE__)
require File.expand_path('../dummy/config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

Dir[Rails.root.join('../support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
