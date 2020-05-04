class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change

    create_table :currencies do |t|
      t.string   :iso4217_alpha, limit: 3, index: true, unique: true
      t.string   :name,                    index: true
      t.string   :minor_unit,    limit: 3
    end

  end
end
