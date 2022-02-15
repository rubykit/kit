module Kit::Domain::Services::Event

  # Persist event & fire a generic event_model|created event
  def self.persist_event(name:, data:, metadata: nil)
    Kit::Organizer.call(
      list: [
        self.method(:create_event_model),
        self.method(:send_event_model_created_event),
      ],
      ctx:  {
        name:     name,
        data:     data,
        metadata: metadata,
      },
    )
  end

  # Persist the event in a database
  def self.create_event_model(name:, data:, metadata: nil)
    metadata ||= {}

    event_model = Kit::Domain::Models::Write::Event.create({
      name:     name,
      data:     data,
      metadata: metadata,
    })

    [:ok, event_model: event_model]
  end

  # Fire a generic event_model|created event
  def self.send_event_model_created_event(event_model:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|event_model|created',
      adapter_name: :async,
      params:       {
        event_model_id: event_model.id,
      },
    )

    [:ok]
  end

end
