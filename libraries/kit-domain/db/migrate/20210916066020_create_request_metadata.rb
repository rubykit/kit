class CreateRequestMetadata < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    create_table   :request_metadata do |t|
      t.datetime   :created_at, index: true, null: false
      t.datetime   :deleted_at, index: true, default: nil

      t.inet       :ip,                      null: false
      t.jsonb      :data,                    null: false, default: {}
      t.jsonb      :utm,                     null: false, default: {}
    end
  end

end
