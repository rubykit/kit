# Exemple type for dummy app.
class Kit::JsonApiSpec::Resources::BookStore < Kit::JsonApiSpec::Resources::Resource

  def self.name
    :book_store
  end

  def self.model_read
    Kit::JsonApiSpec::Models::Read::BookStore
  end

  def self.model_write
    Kit::JsonApiSpec::Models::Write::BookStore
  end

  def self.fields_setup
    {
      id:         { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at: { type: :date },
      updated_at: { type: :date },
      in_stock:   { type: :boolean },
    }
  end

  def self.relationships
    {
      book:  {
        resource:          :book,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: :kit_json_api_spec_book_id],
      },
      store: {
        resource:          :store,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: :kit_json_api_spec_store_id],
      },
    }
  end

  def self.writeable_attributes
    {
      in_stock: :in_stock,
    }
  end

=begin
  def self.resource_url(resource_id:)
    "/book_stores/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/book_stores/#{ resource_id }/relationships/#{ relationship_id }"
  end
=end

end
