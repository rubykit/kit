data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

data[:stores].each do |el_data|
  Kit::JsonApiSpec::Models::Write::Store.create!(el_data)
rescue StandardError => e
  puts e
end
