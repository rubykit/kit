class CreateRequestMetadata < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    create_table   :request_metadata do |t|
      t.datetime   :created_at, index: true, null: false
      t.datetime   :deleted_at, index: true, default: nil

      t.references :user,       index: true

      t.inet       :ip,                      null: false
      t.text       :user_agent,              null: false
      t.jsonb      :utm
    end
  end

end
