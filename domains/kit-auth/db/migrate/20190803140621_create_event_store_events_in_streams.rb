class CreateEventStoreEventsInStreams < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    create_table(:event_store_events_in_streams, force: false) do |t|
      t.datetime    :created_at,  null: false

      t.string      :stream,      null: false
      t.integer     :position,    null: true

      t.references  :event, null: false, type: :uuid
    end

    add_index :event_store_events_in_streams, [:stream, :position], unique: true
    add_index :event_store_events_in_streams, [:created_at]
    add_index :event_store_events_in_streams, [:stream, :event_id], unique: true
  end

end
