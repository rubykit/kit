after :'fantasy_data:empty' do

  Kit::Api::Log.log(msg: 'seeding defaults `fantasy_data:photos`', flags: [:debug, :db, :seed])

  model_class = Kit::JsonApiSpec::Models::Write::Photo

  data = JSON.parse(File.read(File.expand_path('./fantasy_data.json', __dir__)), symbolize_names: true)

  data[:photos].each do |el_data|
    id   = el_data.delete(:imageable_id)
    type = el_data.delete(:imageable_type)

    case type
    when 'authors'
      target_model_class = Kit::JsonApiSpec::Models::Write::Author
    when 'books'
      target_model_class = Kit::JsonApiSpec::Models::Write::Book
    when 'series'
      target_model_class = Kit::JsonApiSpec::Models::Write::Serie
    end

    el_data[:imageable] = target_model_class.find(id)

    model_class.create!(el_data)
  rescue StandardError => e
    puts e
  end

  model_class.connection.reset_pk_sequence!(model_class.table_name)

end
