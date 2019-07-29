class CreateUserActionTokens < ActiveRecord::Migration[5.2]

  def change
    create_table   :user_action_tokens do |t|
      t.timestamps                                         null: false
      t.datetime   :deleted_at, default: nil, index: true

      t.string     :category

      t.references :user,                     index: true, null: false, foreign_key: true

      t.text       :token,                    index: true, null: false
      t.integer    :expires_in, default: 0
      t.datetime   :used_at,    default: nil
    end
  end

end
