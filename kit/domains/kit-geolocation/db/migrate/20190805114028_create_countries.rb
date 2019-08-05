class CreateCountries < ActiveRecord::Migration[5.2]
  def change

    create_table   :countries do |t|
      t.string     :iso3166_alpha2,  limit: 2, index: true, unique: true
      t.string     :iso3166_alpha3,  limit: 3, index: true
      t.string     :name,                      index: true

      t.references :currency,                  index: true, foreign_key: true
    end

  end
end
