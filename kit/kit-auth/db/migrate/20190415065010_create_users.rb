# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]

  def change
    create_table :users do |t|
      t.timestamps null: false
      t.datetime :deleted_at, default: nil

      t.string :email, null: false
    end

    add_index :users, :email
    add_index :users, :deleted_at
    add_index :users, [:email, :deleted_at], where: "deleted_at IS NULL", unique: true
  end

end
