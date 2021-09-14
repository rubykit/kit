class CreateEventStoreEvents < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    enable_extension 'pgcrypto'

    create_table(:event_store_events, id: :uuid, default: 'gen_random_uuid()', force: false) do |t|
      t.datetime    :created_at,  null: false

      t.string      :event_type,  null: false

      t.jsonb       :metadata

      t.jsonb       :data,        null: false
    end

    add_index :event_store_events, :created_at
    add_index :event_store_events, :event_type

    add_index :event_store_events, :metadata,   using: :gin
    add_index :event_store_events, :data,       using: :gin
  end

end
