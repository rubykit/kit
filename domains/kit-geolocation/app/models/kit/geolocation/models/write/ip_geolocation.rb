module Kit::Geolocation::Models::Write
  class IpGeolocation < Kit::Geolocation::Models::WriteRecord
    self.table_name = 'ip_geolocations'



    self.allowed_columns = [
      :id,
      :ip_start,
      :ip_end,
      :country_id,
    ]

    belongs_to :country,
               class_name: 'Kit::Geolocation::Models::Read::Country'

  end
end
