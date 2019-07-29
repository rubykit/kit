require 'database_cleaner'

RSpec.configure do |config|

  config.before(:suite) do
    [Kit::Auth::Models::WriteRecord].each do |model|
      cleaner = DatabaseCleaner[:active_record, { model: model }]
      cleaner.clean_with(:truncation)
      cleaner.strategy = :truncation
    end
  end

end