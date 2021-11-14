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

scheme = ENV['SCHEME'] || 'http'
host   = ENV['HOST']
port   = ENV['PORT']

if !host
  raise 'Capybara: please set environment HOST explicitely (this will avoid localhost vs 127.0.0.1 issues)'
end

if !port
  raise 'Capybara: please set environment PORT explicitely (this will avoid app & capybara generating url with different port)'
end

Capybara.server_port  = port
Capybara.default_host = "#{ scheme }://#{ host }:#{ port }"
Capybara.app_host     = Capybara.default_host

RSpec.configure do |config|

  config.use_transactional_fixtures = false

end
