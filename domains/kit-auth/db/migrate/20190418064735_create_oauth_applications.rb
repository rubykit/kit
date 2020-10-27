class CreateOauthApplications < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation

  def change
    create_table :oauth_applications do |t|
      t.timestamps null: false
      t.datetime   :deleted_at,         default: nil, index: true

      t.string     :name,                                          null: false
      t.string     :uid,                              index: true, null: false
      t.string     :secret,                                        null: false
      t.text       :redirect_uri,                                  null: false
      t.string     :scopes,             default: '',               null: false
      t.boolean    :confidential,       default: true,             null: false
    end
  end

end
