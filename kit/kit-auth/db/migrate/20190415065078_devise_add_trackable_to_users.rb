# frozen_string_literal: true

class DeviseAddTrackableToUsers < ActiveRecord::Migration[5.2]

=begin
  def change
    change_table :users do |t|
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip
    end
  end
=end

end
