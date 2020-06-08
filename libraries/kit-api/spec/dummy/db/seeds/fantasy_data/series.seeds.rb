data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

data[:series].each do |el_data|
  el_data.delete(:photo_id)
  Kit::JsonApiSpec::Models::Write::Serie.create!(el_data)
rescue StandardError => e
  puts e
end
