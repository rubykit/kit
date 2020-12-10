require 'database_cleaner'
require 'rake'
require 'seedbank'

# ### References
# - https://gist.github.com/jsteiner/8362013

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)

    Seedbank.seeds_root = File.expand_path('../dummy/db/seeds', __dir__)
    Seedbank.load_tasks if defined?(Seedbank)

    Kit::DummyAppContainer::Application.load_tasks
    Rake::Task['db:seed:fantasy_data'].invoke
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)
  end

end
