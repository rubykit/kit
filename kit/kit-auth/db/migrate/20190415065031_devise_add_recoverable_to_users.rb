# frozen_string_literal: true

class DeviseAddRecoverableToUsers < ActiveRecord::Migration[5.2]

  def change
    change_table :users do |t|
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
    end

    add_index :users, :reset_password_token, unique: true
  end

end
