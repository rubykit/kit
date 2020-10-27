class CreateOauthAccessTokens < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    create_table :oauth_access_tokens do |t|
      t.timestamps null: false
      t.datetime   :deleted_at,         default: nil, index: true

      t.references :resource_owner,                   index: true, null: false, foreign_key: { to_table: :users }
      t.references :application,                      index: true, null: false, foreign_key: { to_table: :oauth_applications }

      t.string     :token,                            index: true, null: false, unique: true
      t.string     :scopes
      t.integer    :expires_in

      t.datetime   :revoked_at

      t.text       :refresh_token,                    index: true,              unique: true

      t.references :last_request_metadata,                                      foreign_key: { to_table: :request_metadata }

      # If there is a previous_refresh_token column,
      # refresh tokens will be revoked after a related access token is used.
      # If there is no previous_refresh_token column,
      # previous tokens are revoked as soon as a new access token is created.
      # Comment out this line if you'd rather have refresh tokens
      # instantly revoked.
      # t.string   :previous_refresh_token, default: "",            null: false
    end
  end

end
