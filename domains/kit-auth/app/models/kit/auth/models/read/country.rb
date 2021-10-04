module Kit::Auth::Models::Read
  class Country < Kit::Auth::Models::ReadRecord

    self.table_name = 'countries'

    self.allowed_columns = [
      :id,
      :iso3166_alpha2,
      :iso3166_alpha3,
      :name,
      :currency_id,
    ]

    has_many :ip_geolocations,
      class_name: 'Kit::Auth::Models::Read::IpGeolocation'

    def model_verbose_name
      "#{ model_log_name }|#{ name }"
    end

  end
end
