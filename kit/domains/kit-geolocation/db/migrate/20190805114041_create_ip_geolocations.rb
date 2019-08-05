class CreateIpGeolocations < ActiveRecord::Migration[5.2]
  def change
    create_table   :ip_geolocations do |t|
      t.inet       :ip_start,   index: true
      t.inet       :ip_end,     index: true
      t.references :country,    index: true, foreign_key: true
    end
  end
end
