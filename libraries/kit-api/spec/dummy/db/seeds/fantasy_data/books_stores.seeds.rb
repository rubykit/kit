after :'fantasy_data:books', :'fantasy_data:stores' do

  data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

  data[:books_stores].each do |el_data|
    el_data[:kit_json_api_spec_book_id]  = el_data.delete(:book_id)
    el_data[:kit_json_api_spec_store_id] = el_data.delete(:store_id)
    Kit::JsonApiSpec::Models::Write::BookStore.create!(el_data)
  rescue StandardError => e
    puts e
  end

end
