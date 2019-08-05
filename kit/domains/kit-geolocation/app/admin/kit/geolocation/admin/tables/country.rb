require_relative 'base_table'

class Kit::Geolocation::Admin::Tables::Country < Kit::Geolocation::Admin::Tables::BaseTable

  def attributes_for_all
    {
      id:              nil,
      name:            :code,
      flag:            [:flag, ->(el) { el }],
      iso3166_alpha3:  :code,
      iso3166_alpha2:  :code,
      currency:        :model_verbose,
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