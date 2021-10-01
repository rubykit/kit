require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/apparition'

Capybara.register_driver :apparition do |app|
  options = {
    headless: ![false, 'false'].include?(ENV['CAPYBARA_HEADLESS']),
  }

  Capybara::Apparition::Driver.new(app, options)
end

Capybara.default_driver    = :rack_test
Capybara.javascript_driver = :apparition

RSpec.configure do |config|

  config.use_transactional_fixtures = false

end
