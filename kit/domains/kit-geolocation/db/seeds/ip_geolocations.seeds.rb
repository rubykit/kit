after :countries do

  list = CSV.read(File.join(__dir__, 'seeds.ip_geolocations.dbip-country-lite-2019-08.csv'))

  list.each do |el|
    begin
      ip_start_string = el[0]
      ip_end_string   = el[1]
      country         = el[2]

      next if ip_start_string.blank?

      Kit::Geolocation::Models::Write::IpGeolocation
        .create_with({
          country_id: Kit::Geolocation::Models::Read::Country.find_by(iso3166_alpha2: country)&.id,
        })
        .find_or_create_by!({
          ip_start: ip_start_string,
          ip_end:   ip_end_string,
        })
    rescue => e
      puts e
    end
  end

end
