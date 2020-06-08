after :'fantasy_data:authors', :'fantasy_data:series' do

  data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

  data[:books].each do |el_data|
    el_data[:kit_json_api_spec_author_id] = el_data.delete(:author_id)
    el_data[:kit_json_api_spec_serie_id]  = el_data.delete(:series_id)
    Kit::JsonApiSpec::Models::Write::Book.create!(el_data)
  rescue StandardError => e
    puts e
  end

end
