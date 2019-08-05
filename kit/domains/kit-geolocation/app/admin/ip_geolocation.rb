ActiveAdmin.register Kit::Geolocation::Models::Write::IpGeolocation, as: 'IpGeolocation', namespace: :kit_geolocation_admin do
  menu parent: 'Countries'

  actions :all, except: [:new, :edit, :destroy]

  config.sort_order = 'id_asc'

  filter :id,         filters: ['eq']
  filter :ip_start
  filter :ip_end
  filter :country_id, filters: ['eq']

  controller do
    def scoped_collection
      super.preload(:country)
    end
  end

  index do
    Kit::Geolocation::Admin::Tables::IpGeolocation.new(self).index
  end

  csv do
    Kit::Geolocation::Admin::Tables::IpGeolocation.new(self).csv
  end

  show do
    Kit::Geolocation::Admin::Tables::IpGeolocation.new(self).panel resource, title: 'Details'
  end

end
