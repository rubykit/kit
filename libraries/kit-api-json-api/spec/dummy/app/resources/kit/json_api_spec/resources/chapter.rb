# Exemple type for dummy app.
class Kit::JsonApiSpec::Resources::Chapter < Kit::Api::JsonApi::Resources::ActiveRecordResource

  def self.name
    :chapter
  end

  def self.model
    Kit::JsonApiSpec::Models::Write::Chapter
  end

  def self.fields_setup
    {
      id:       { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      title:    { type: :string },
      ordering: { type: :numeric },
    }
  end

  def self.relationships
    {
      book:   {
        resource:          :book,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: :kit_json_api_spec_book_id],
      },
      photos: {
        resource:          :photo,
        relationship_type: :to_many,
        resolvers:         [:active_record, child_field: { id: :imageable_id, type: :imageable_type, model_name: 'Kit::JsonApiSpec::Models::Write::Chapter' }],
      },
    }
  end

  def self.record_serializer(record:)
    query_node = record[:query_node]
    resource   = query_node[:resource]
    raw_data   = record[:raw_data]

    resource_object = {
      type:       resource[:name],
      id:         raw_data[:id].to_s,
      attributes: raw_data.slice(resource[:fields] - [:id, :ordering]).merge(ordering: raw_data[:index]),
    }

    [:ok, resource_object: resource_object]
  end

=begin

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Chapter::Relationships::Book,
    ]

    list
      .map { |el| [el.relationship[:name], el.relationship] }
      .to_h
  end

  def self.resource_url(resource_id:)
    "/chapters/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/chapters/#{ resource_id }/relationships/#{ relationship_id }"
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :chapter },
  ]
  def self.load_data(query_node:)
    model  = Kit::JsonApiSpec::Models::Write::Chapter
    _, ctx = Kit::Api::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA CHAPTER: #{ data.size }"

    [:ok, data: data]
  end

=end



end
