module Kit::Auth::Models::Read
  class IpGeolocation < Kit::Auth::Models::ReadRecord

    self.table_name = 'ip_geolocation'

    self.allowed_columns = [
      :id,
      :ip_start,
      :ip_end,
      :country_id,
    ]

    belongs_to :country,
      class_name: 'Kit::Auth::Models::Read::Country'

  end
end
