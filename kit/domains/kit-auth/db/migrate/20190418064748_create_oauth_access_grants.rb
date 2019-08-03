class CreateOauthAccessGrants < ActiveRecord::Migration[5.2]

  def change
    create_table   :oauth_access_grants do |t|
      t.timestamps                                                 null: false
      t.datetime   :deleted_at,         default: nil, index: true

      t.references :resource_owner,                   index: true, null: false, foreign_key: { to_table: :users }
      t.references :application,                      index: true, null: false, foreign_key: { to_table: :oauth_applications }

      t.string     :token,                            index: true, null: false, unique: true
      t.string     :scopes
      t.integer    :expires_in,                                    null: false

      t.datetime   :revoked_at

      t.text       :redirect_uri,                                  null: false
    end
  end

end
