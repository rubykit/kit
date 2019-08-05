list = JSON.parse(File.read(File.join(__dir__, 'country-codes.datahub.io.json')))

list.each do |el|
  begin
    iso3166_alpha2 = el['ISO3166-1-Alpha-2']
    next if iso3166_alpha2.blank?

    Kit::Geolocation::Models::Write::Country
      .create_with({
        iso3166_alpha3: el['ISO3166-1-Alpha-3'],
        name:           el['CLDR display name'],
        currency_id:    Kit::Geolocation::Models::Read::Currency.find_by(iso4217_alpha: el['ISO4217-currency_alphabetic_code'])&.id,
      })
      .find_or_create_by!({
        iso3166_alpha2: iso3166_alpha2,
      })

  rescue => e
    puts e
  end
end