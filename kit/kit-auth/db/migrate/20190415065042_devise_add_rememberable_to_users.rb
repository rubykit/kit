# frozen_string_literal: true

class DeviseAddRememberableToUsers < ActiveRecord::Migration[5.2]

  def change
    change_table :users do |t|
      t.datetime :remember_created_at
    end
  end

end
