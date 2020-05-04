module Kit::Events::Actions::CreateEvent

  def self.call(type:, data:, targets: nil)
    raw_event = type.new(data: data)

    Rails.configuration.event_store.publish(raw_event)

    event = Kit::Domain::Models::Read::Event.find(raw_event.event_id)

    controller_params = {
      event_id: event.id,
    }

    if targets
      controller_params[:targets] = targets
    end

    Kit::Router
      .delay
      .call(id: 'system|events|process', params: controller_params)

    [:ok, event: event]
  end

end