after :'fantasy_data:authors', :'fantasy_data:series' do

  Kit::Api::Log.log(msg: 'seeding defaults `fantasy_data:books`', flags: [:debug, :db, :seed])

  model_class = Kit::JsonApiSpec::Models::Write::Book

  data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

  data[:books].each do |el_data|
    el_data[:kit_json_api_spec_author_id] = el_data.delete(:author_id)
    el_data[:kit_json_api_spec_serie_id]  = el_data.delete(:series_id)
    model_class.create!(el_data)
  rescue StandardError => e
    puts e
  end

  model_class.connection.reset_pk_sequence!(model_class.table_name)

end
