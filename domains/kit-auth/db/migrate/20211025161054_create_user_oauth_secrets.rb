class CreateUserOauthSecrets < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    create_table :user_oauth_secrets do |t|
      t.timestamps                                     null: false
      t.datetime   :deleted_at,           index: true, default: nil

      t.references :user_oauth_identity,  index: true, null: false, foreign_key: true

      t.string     :provider_app_id,                   null: false
      t.text       :secret_token,                      null: false
      t.text       :secret_refresh_token,              default: nil
      t.datetime   :expires_at,                        default: nil
    end

    add_index :user_oauth_secrets, [:user_oauth_identity_id, :provider_app_id, :secret_token], where: 'deleted_at IS NULL', unique: true, name: 'index_user_oauth_secrets_token_unique'
    add_index :user_oauth_secrets, [:user_oauth_identity_id, :provider_app_id, :secret_token, :deleted_at],                               name: 'index_user_oauth_secrets_token_deleted_at'
  end

end
