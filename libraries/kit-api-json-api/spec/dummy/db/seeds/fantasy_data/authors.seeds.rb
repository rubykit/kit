data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

data[:authors].each do |el_data|
  Kit::JsonApiSpec::Models::Write::Author.create!(el_data)
rescue StandardError => e
  puts e
end
