module Kit::Events::Services::Event

  def self.create_event(name:, data:, metadata: nil)
    metadata ||= {}

    event_model = Kit::Events::Models::Write::Event.create({
      name:     name,
      data:     data,
      metadata: metadata,
    })

    [:ok, event_model: event_model]
  end

end
