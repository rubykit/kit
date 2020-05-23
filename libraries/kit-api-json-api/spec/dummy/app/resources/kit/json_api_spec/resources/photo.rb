# Exemple type for dummy app.
class Kit::JsonApiSpec::Resources::Photo < Kit::Api::JsonApi::Resources::ActiveRecordResource

  def self.name
    :photo
  end

  def self.model
    Kit::JsonApiSpec::Models::Write::Photo
  end

  def self.fields_setup
    {
      id:         { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at: { type: :date },
      updated_at: { type: :date },
      title:      { type: :string },
      uri:        { type: :string },
    }
  end

  def self.relationships
    {
      author:  {
        resource:          :author,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: { id: :imageable_id, type: :imageable_type, model_name: 'Kit::JsonApiSpec::Models::Write::Author' }],
      },
      book:    {
        resource:          :book,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: { id: :imageable_id, type: :imageable_type, model_name: 'Kit::JsonApiSpec::Models::Write::Book' }],
      },
      chapter: {
        resource:          :chapter,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: { id: :imageable_id, type: :imageable_type, model_name: 'Kit::JsonApiSpec::Models::Write::Chapter' }],
      },
      serie:   {
        resource:          :serie,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: { id: :imageable_id, type: :imageable_type, model_name: 'Kit::JsonApiSpec::Models::Write::Serie' }],
      },
    }
  end

=begin

  def self.resource_url(resource_id:)
    "/photos/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/photos/#{ resource_id }/relationships/#{ relationship_id }"
  end

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Photo::Relationships::Author,
      Kit::JsonApiSpec::Resources::Photo::Relationships::Book,
      Kit::JsonApiSpec::Resources::Photo::Relationships::Chapter,
      Kit::JsonApiSpec::Resources::Photo::Relationships::Serie,
    ]

    list
      .map { |el| [el.relationship[:name], el.relationship] }
      .to_h
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :photo },
  ]
  def self.load_data(query_node:)
    model  = Kit::JsonApiSpec::Models::Write::Photo
    _, ctx = Kit::Api::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA PHOTO: #{ data.size }"

    [:ok, data: data]
  end

=end

end
