after :'fantasy_data:books' do

  data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

  data[:chapters].each do |el_data|
    el_data[:kit_json_api_spec_book_id] = el_data.delete(:book_id)
    el_data[:index]                     = el_data.delete(:ordering)
    Kit::JsonApiSpec::Models::Write::Chapter.create!(el_data)
  rescue StandardError => e
    puts e
  end

end
