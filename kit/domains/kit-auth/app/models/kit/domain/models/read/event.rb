module Kit::Domain::Models::Read
  class Event < Kit::Domain::Models::ReadRecord
    self.table_name = 'event_store_events'



    self.whitelisted_columns = [
      :id,
      :event_type,
      :metadata,
      :data,
      :created_at,
    ]

    has_many :stream_events,
             class_name: 'Kit::Eventable::Models::Read::StreamEvent',
             foreign_key: :event_id

  end
end
