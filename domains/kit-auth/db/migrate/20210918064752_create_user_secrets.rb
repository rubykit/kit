class CreateUserSecrets < ActiveRecord::Migration[6.1] # rubocop:disable Style/Documentation

  def change
    create_table   :user_secrets do |t|
      t.timestamps                                null: false
      t.datetime   :deleted_at,      index: true, default: nil

      t.references :application,     index: true, null: false, foreign_key: { to_table: :applications }
      t.references :user,            index: true, null: false, foreign_key: { to_table: :users }

      t.string     :category,        index: true, null: false
      t.string     :scopes,          index: true, null: false

      t.string     :secret,          index: true, null: false, unique: true
      t.string     :secret_strategy, index: true, null: false

      t.integer    :expires_in
      t.datetime   :revoked_at

      t.jsonb      :data,                         null: false, default: {}
    end

    # Unique non deleted secrets
    add_index :user_secrets, [:secret,  :secret_strategy], name: 'index_user_secrets_unique_secret', where: 'deleted_at IS NULL', unique: true

    # Indexes for soft-delete column
    add_index :user_secrets, [:deleted_at, :user_id]
    add_index :user_secrets, [:deleted_at, :secret, :secret_strategy]
  end

end
