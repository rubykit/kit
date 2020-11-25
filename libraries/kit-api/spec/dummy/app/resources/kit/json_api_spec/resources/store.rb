# Exemple type for dummy app.
class Kit::JsonApiSpec::Resources::Store < Kit::JsonApiSpec::Resources::Resource

  def self.name
    :store
  end

  def self.model_read
    Kit::JsonApiSpec::Models::Read::Store
  end

  def self.model_write
    Kit::JsonApiSpec::Models::Write::Store
  end

  def self.fields_setup
    {
      id:         { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at: { type: :date },
      updated_at: { type: :date },
      name:       { type: :string },
    }
  end

  def self.relationships
    {
      book_store: {
        resource:          :book_store,
        relationship_type: :to_many,
        resolvers:         [:active_record, child_field: :kit_json_api_spec_store_id],
      },
    }
  end

=begin
  def self.resource_url(resource_id:)
    "/stores/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/stores/#{ resource_id }/relationships/#{ relationship_id }"
  end
=end

end
