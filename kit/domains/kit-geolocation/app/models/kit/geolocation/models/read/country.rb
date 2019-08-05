module Kit::Geolocation::Models::Read
  class Country < Kit::Geolocation::Models::ReadRecord
    self.table_name = 'countries'



    self.whitelisted_columns = [
      :id,
      :iso3166_alpha2,
      :iso3166_alpha3,
      :name,
      :currency_id,
    ]

    belongs_to :currency,
               class_name: 'Kit::Geolocation::Models::Read::Currency'

    has_many   :ip_geolocations,
               class_name: 'Kit::Geolocation::Models::Read::IpGeolocation'

    def model_verbose_name
      "#{model_log_name}|#{name}"
    end

  end
end
