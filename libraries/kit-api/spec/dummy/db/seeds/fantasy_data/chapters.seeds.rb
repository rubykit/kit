after :'fantasy_data:books' do

  Kit::Api::Log.log(msg: 'seeding defaults `fantasy_data:chapters`', flags: [:debug, :db, :seed])

  model_class = Kit::JsonApiSpec::Models::Write::Chapter

  data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

  data[:chapters].each do |el_data|
    el_data[:kit_json_api_spec_book_id] = el_data.delete(:book_id)
    el_data[:index]                     = el_data.delete(:ordering)
    model_class.create!(el_data)
  rescue StandardError => e
    puts e
  end

  model_class.connection.reset_pk_sequence!(model_class.table_name)

end
