after :'fantasy_data:empty' do

  Kit::Api::Log.log(msg: 'seeding defaults `fantasy_data:stores`', flags: [:debug, :db, :seed])

  model_class = Kit::JsonApiSpec::Models::Write::Store

  data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

  data[:stores].each do |el_data|
    model_class.create!(el_data)
  rescue StandardError => e
    puts e
  end

  model_class.connection.reset_pk_sequence!(model_class.table_name)

end
