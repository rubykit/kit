class CreateApplications < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    create_table :applications do |t|
      t.timestamps                           null: false
      t.datetime   :deleted_at, index: true, default: nil

      t.string     :uid,        index: true, null: false
      t.string     :name,                    null: false
      t.string     :scopes,                  null: false, default: ''

      t.jsonb      :data,                    null: false, default: {}
    end
  end

end
