# Exemple type for dummy app.
class Kit::JsonApiSpec::Resources::Photo < Kit::JsonApiSpec::Resources::Resource

  def self.name
    :photo
  end

  def self.model_read
    Kit::JsonApiSpec::Models::Read::Photo
  end

  def self.model_write
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
=begin
      # TODO: add dynamic relationships?
      target:  {
        resource:          ???,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: { id: :imageable_id, type: :imageable_type, model_name: ??? }],
      },
=end
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

  def self.writeable_attributes
    {
      title: nil,
      uri:   nil,
    }
  end

  def self.writeable_relationships
    {

    }
  end

=begin
  def self.resource_url(resource_id:)
    "/photos/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/photos/#{ resource_id }/relationships/#{ relationship_id }"
  end
=end

end
