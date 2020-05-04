ActiveAdmin.register Kit::Geolocation::Models::Write::Country, as: 'Country', namespace: :kit_geolocation_admin do

  actions :all, except: [:new, :edit, :destroy]

  config.sort_order = 'name_asc'

  filter :id,              filters: ['eq']
  filter :iso3166_alpha3,  filters: ['eq']
  filter :iso3166_alpha2,  filters: ['eq']
  filter :iso3166_numeric, filters: ['eq']
  filter :name,            filters: ['eq']

  controller do
    def scoped_collection
      super.preload(:currency)
    end
  end

  index do
    Kit::Geolocation::Admin::Tables::Country.new(self).index
  end

  csv do
    Kit::Geolocation::Admin::Tables::Country.new(self).csv
  end

  show do
    Kit::Geolocation::Admin::Tables::Country.new(self).panel resource, title: 'Details'

    hr

    relation = resource.ip_geolocations
    Kit::Geolocation::Admin::Tables::IpGeolocation.new(self).panel_list relation, except: [:country] do
      text_node link_to 'See All',
        Kit::Geolocation::Routes.admin_ip_geolocations_path("q[country_id_eq]" => resource.id),
        { class: 'button'}
    end
  end

end
