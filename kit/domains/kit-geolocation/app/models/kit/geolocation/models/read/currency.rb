module Kit::Geolocation::Models::Read
  class Currency < Kit::Geolocation::Models::ReadRecord
    self.table_name = 'currencies'



    self.whitelisted_columns = [
      :id,
      :iso4217_alpha,
      :name,
      :minor_unit,
    ]

    has_many   :countries,
               class_name: 'Kit::Geolocation::Models::Read::Country'

    def model_verbose_name
      "#{model_log_name}|#{iso4217_alpha}"
    end

  end
end
