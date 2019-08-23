module Kit::Domain::Models::Read
  class StreamEvent < Kit::Domain::Models::ReadRecord
    self.table_name = 'event_store_events_in_streams'



    self.whitelisted_columns = [
      :id,
      :created_at,
      :stream,
      :position,
      :event_id,
    ]

    belongs_to :event,
               class_name: 'Kit::Eventable::Models::Read::Event'

  end