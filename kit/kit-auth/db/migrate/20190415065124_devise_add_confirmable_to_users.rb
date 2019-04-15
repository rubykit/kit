# frozen_string_literal: true

class DeviseAddConfirmableToUsers < ActiveRecord::Migration[5.2]

=begin
  def change
    change_table :users do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
    end

    add_index :users, :confirmation_token, unique: true
  end
=end

end
