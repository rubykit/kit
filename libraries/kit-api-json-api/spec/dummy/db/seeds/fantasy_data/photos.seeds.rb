data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

data[:photos].each do |el_data|
  id   = el_data.delete(:imageable_id)
  type = el_data.delete(:imageable_type)

  if type == 'authors'
    model_class = Kit::JsonApiSpec::Models::Write::Author
  elsif type == 'books'
    model_class = Kit::JsonApiSpec::Models::Write::Book
  elsif type == 'series'
    model_class = Kit::JsonApiSpec::Models::Write::Serie
  end

  el_data[:imageable] = model_class.find(id)

  Kit::JsonApiSpec::Models::Write::Photo.create!(el_data)
rescue Exception => e
  puts e
end
