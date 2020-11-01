#require 'test_prof/recipes/rspec/sample'
require 'rspec'
require 'capybara/rspec'

require 'kit-rspec-formatter'

RSpec.configure do |config|

  config.formatter = Kit::RspecFormatter::Formatter

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end
