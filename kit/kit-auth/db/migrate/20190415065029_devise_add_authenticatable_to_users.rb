# frozen_string_literal: true

class DeviseAddAuthenticatableToUsers < ActiveRecord::Migration[5.2]

  def change
    change_table :users do |t|
      t.string :encrypted_password, null: false, default: ''
    end
  end

end
