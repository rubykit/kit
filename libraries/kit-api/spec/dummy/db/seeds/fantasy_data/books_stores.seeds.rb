after :'fantasy_data:books', :'fantasy_data:stores' do

  Kit::Api::Log.log(msg: 'seeding defaults `fantasy_data:books_stores`', flags: [:debug, :db, :seed])

  model_class = Kit::JsonApiSpec::Models::Write::BookStore

  data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

  data[:books_stores].each do |el_data|
    el_data[:kit_json_api_spec_book_id]  = el_data.delete(:book_id)
    el_data[:kit_json_api_spec_store_id] = el_data.delete(:store_id)
    model_class.create!(el_data)
  rescue StandardError => e
    puts e
  end

  model_class.connection.reset_pk_sequence!(model_class.table_name)

end
