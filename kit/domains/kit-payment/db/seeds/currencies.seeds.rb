list = JSON.parse(File.read(File.join(__dir__, 'country-codes.datahub.io.json')))

list.each do |el|
  begin
    iso4217_alpha = el['ISO4217-currency_alphabetic_code']
    next if iso4217_alpha.blank?

    iso4217_alpha      = iso4217_alpha.split(',')
    iso4217_name       = el['ISO4217-currency_name'].split(',')
    iso4217_minor_unit = el['ISO4217-currency_minor_unit'].split(',')

    iso4217_alpha.each_with_index do |el, idx|
      Kit::Payment::Models::Write::Currency
        .create_with({
          name:          iso4217_name[idx],
          minor_unit:    iso4217_minor_unit[idx],
        })
        .find_or_create_by!({
          iso4217_alpha: iso4217_alpha[idx],
        })
    end

  rescue => e
    puts e
    binding.pry
  end
end
