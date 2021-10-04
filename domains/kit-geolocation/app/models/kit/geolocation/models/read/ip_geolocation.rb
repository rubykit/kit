module Kit::Geolocation::Models::Read
  class IpGeolocation < Kit::Geolocation::Models::ReadRecord
    self.table_name = 'ip_geolocation'



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
