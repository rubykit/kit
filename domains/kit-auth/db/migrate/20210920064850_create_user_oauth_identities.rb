class CreateUserOauthIdentities < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    create_table :user_oauth_identities do |t|
      t.timestamps                           null: false
      t.datetime   :deleted_at, index: true, default: nil

      t.references :user,       index: true, null: false, foreign_key: true

      t.string     :provider,   index: true, null: false
      t.string     :uid,        index: true, null: false

      # NOTE: should probably be UserSecret?
      t.text       :token,                   null: false
      t.integer    :expires_at,              default: nil

      t.jsonb      :data
    end

    add_index :user_oauth_identities, [:provider, :uid], where: 'deleted_at IS NULL', unique: true
    add_index :user_oauth_identities, [:provider, :uid, :deleted_at]
  end

end
