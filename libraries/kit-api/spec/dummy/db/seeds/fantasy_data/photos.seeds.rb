data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

data[:photos].each do |el_data|
  id   = el_data.delete(:imageable_id)
  type = el_data.delete(:imageable_type)

  case type
  when 'authors'
    model_class = Kit::JsonApiSpec::Models::Write::Author
  when 'books'
    model_class = Kit::JsonApiSpec::Models::Write::Book
  when 'series'
    model_class = Kit::JsonApiSpec::Models::Write::Serie
  end

  el_data[:imageable] = model_class.find(id)

  Kit::JsonApiSpec::Models::Write::Photo.create!(el_data)
rescue StandardError => e
  puts e
end
