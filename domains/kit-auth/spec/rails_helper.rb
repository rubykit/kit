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

require 'kit/dummy_app_container/rails_rspec'

require 'spec_helper'

Dir[File.expand_path('support/**/*.rb', __dir__)].sort.each { |f| require f } # rubocop:disable Lint/RedundantDirGlobSort
require 'kit/domain/spec/support/helpers/routes'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include Kit::Domain::Spec::Support::Helpers::Routes

  config.include Helpers::Applications
  config.include Helpers::Users
  config.include Helpers::WebAuthentication, type: :feature

  config.include Helpers::Omniauth::Facebook

end
