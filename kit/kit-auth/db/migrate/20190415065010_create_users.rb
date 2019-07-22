class CreateUsers < ActiveRecord::Migration[5.2]

  def change
    create_table   :users do |t|
      t.timestamps                                            null: false
      t.datetime   :deleted_at,    default: nil, index: true

      t.string     :email,                       index: true, null: false
      t.string     :hashed_secret, default: nil
      t.datetime   :confirmed_at,  default: nil, index: true
      t.date
    end

    add_index :users, [:email, :deleted_at], where: "deleted_at IS NULL", unique: true
  end

end
