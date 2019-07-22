class CreateOauthIdentities < ActiveRecord::Migration[5.2]

  def change
    create_table   :oauth_identities do |t|
      t.timestamps                                                 null: false
      t.datetime   :deleted_at,         default: nil, index: true

      t.references :user,                             index: true, null: false, foreign_key: true

      t.string     :provider,                         index: true, null: false
      t.string     :uid,                              index: true, null: false

      t.text       :token,                            index: true, null: false
      t.text       :secret
      t.integer    :expires_at,         default: nil

      t.jsonb      :info
      t.jsonb      :extra
    end

    add_index :oauth_identities, [:provider, :uid, :deleted_at], where: "deleted_at IS NULL", unique: true
  end

end
