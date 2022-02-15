class CreateEvents < ActiveRecord::Migration[6.1] # rubocop:disable Style/Documentation

  def change
    enable_extension 'pgcrypto'

    create_table(:events, id: :uuid, default: 'gen_random_uuid()', force: false) do |t|
      t.datetime    :created_at,  null: false
      t.datetime    :emitted_at
      t.datetime    :deleted_at

      t.string      :name,        null: false
      t.jsonb       :data,        null: false, default: {}
      t.jsonb       :metadata,    null: false, default: {}
    end

    add_index :events, :deleted_at
    add_index :events, [:id,         :deleted_at]
    add_index :events, [:created_at, :deleted_at]
    add_index :events, [:emitted_at, :deleted_at]
    add_index :events, [:name,       :deleted_at]

    add_index :events, :metadata, using: :gin
    add_index :events, :data,     using: :gin
  end

end
