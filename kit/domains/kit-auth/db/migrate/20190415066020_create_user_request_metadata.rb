class CreateUserRequestMetadata < ActiveRecord::Migration[5.2]

  def change
    create_table :user_request_metadata do |t|
      t.timestamps                                                 null: false
      t.datetime   :deleted_at,         default: nil, index: true

      t.references :user,                             index: true, null: false

      t.inet       :ip,                                            null: false
      t.text       :user_agent,                                    null: false
      t.jsonb      :utm
    end
  end

end
