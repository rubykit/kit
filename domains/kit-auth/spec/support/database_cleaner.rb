require 'database_cleaner'

RSpec.configure do |config|

  # TODO: optimize this per category of test. Maybe add a `:db` flag?
  config.before(:each) do
    [Kit::Auth::Models::WriteRecord].each do |model|
      cleaner = DatabaseCleaner[:active_record, { model: model }]
      cleaner.clean_with(:truncation)
      cleaner.strategy = :truncation
    end

    load File.expand_path('../../db/seeds/oauth_applications.seeds.rb', __dir__)
  end

end
