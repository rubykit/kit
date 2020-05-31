if ENV['EVENT_STORE'] != 'false'

  require 'rails_event_store'

  Rails.application.configure do
    config.to_prepare do
      Rails.configuration.event_store = RailsEventStore::Client.new(
        mapper: RubyEventStore::Mappers::Default.new(
          serializer: JSON,
        ),
      )
    end
  end

end
