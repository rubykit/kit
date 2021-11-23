class CreateUserOauthIdentities < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    create_table :user_oauth_identities do |t|
      t.timestamps                             null: false
      t.datetime   :deleted_at,   index: true, default: nil

      t.references :user,         index: true, null: false, foreign_key: true

      t.string     :provider,     index: true, null: false
      t.string     :provider_uid, index: true, null: false

      t.jsonb      :data,                      null: false, default: {}
    end

    add_index :user_oauth_identities, [:provider, :provider_uid], where: 'deleted_at IS NULL', unique: true, name: 'index_user_oauth_providers_unique'
    add_index :user_oauth_identities, [:provider, :provider_uid, :deleted_at],                               name: 'index_user_oauth_providers_deleted_at'
  end

end
