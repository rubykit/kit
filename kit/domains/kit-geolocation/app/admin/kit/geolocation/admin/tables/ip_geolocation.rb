require_relative 'base_table'

class Kit::Geolocation::Admin::Tables::IpGeolocation < Kit::Geolocation::Admin::Tables::BaseTable

  def attributes_for_all
    {
      id:         nil,
      #ip_start:   [:code, ->(el) { IPAddr.new_ntoh(el.ip_start) }],
      #ip_end:     [:code, ->(el) { IPAddr.new_ntoh(el.ip_end)   }],

      ip_start:   :code,
      ip_end:     :code,
      country:    :country,
    }
  end

  def attributes_for_index
    attributes_for_all
  end

  def attributes_for_list
    attributes_for_index
  end

  def attributes_for_show
    attributes_for_all
  end

end