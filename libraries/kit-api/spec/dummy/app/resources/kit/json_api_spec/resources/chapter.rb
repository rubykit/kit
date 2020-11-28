# Exemple type for dummy app.
class Kit::JsonApiSpec::Resources::Chapter < Kit::JsonApiSpec::Resources::Resource

  def self.name
    :chapter
  end

  def self.model_read
    Kit::JsonApiSpec::Models::Read::Chapter
  end

  def self.model_write
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

  def self.writeable_attributes
    {
      title: :title,
      index: :index,
    }
  end

=begin
  def self.resource_url(resource_id:)
    "/chapters/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/chapters/#{ resource_id }/relationships/#{ relationship_id }"
  end
=end

end
