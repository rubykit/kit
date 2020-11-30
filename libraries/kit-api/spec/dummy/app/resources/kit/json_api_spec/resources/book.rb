# Exemple type for dummy app.
class Kit::JsonApiSpec::Resources::Book < Kit::JsonApiSpec::Resources::Resource

  def self.name
    :book
  end

  def self.model_read
    Kit::JsonApiSpec::Models::Read::Book
  end

  def self.model_write
    Kit::JsonApiSpec::Models::Write::Book
  end

  def self.fields_setup
    {
      id:             { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
      created_at:     { type: :date },
      updated_at:     { type: :date },
      title:          { type: :string },
      date_published: { type: :date, sort_field: { order: :desc } },
    }
  end

  def self.relationships
    {
      author:        {
        resource:          :author,
        relationship_type: :to_one,
        resolvers:         [:active_record, parent_field: :kit_json_api_spec_author_id],
      },
      book_stores:   {
        resource:          :book_store,
        relationship_type: :to_many,
        resolvers:         [:active_record, child_field: :kit_json_api_spec_book_id],
      },
      chapters:      {
        resource:          :chapter,
        relationship_type: :to_many,
        resolvers:         [:active_record, child_field: :kit_json_api_spec_book_id],
      },
      first_chapter: {
        resource:          :chapter,
        relationship_type: :to_one,
        resolvers:         {
          inherited_filter: Kit::Api::Services::Resolvers::ActiveRecord.generate_inherited_filters(relationship_type: :to_many, parent_field: { id: :id }, child_field: { id: :kit_json_api_spec_book_id }),
          records_selector: Kit::Api::Services::Resolvers::ActiveRecord.generate_records_selector(relationship_type: :to_many, parent_field: { id: :id }, child_field: { id: :kit_json_api_spec_book_id }),
          data_resolver:    Kit::Api::Services::Resolvers::ActiveRecord.generate_data_resolver({
            model: Kit::JsonApiSpec::Models::Write::Chapter,
          })[1][:data_resolver],
        },
      },
      photos:        {
        resource:          :photo,
        relationship_type: :to_many,
        resolvers:         [:active_record, foreign_key_field: [:imageable_id, :imageable_type, 'Kit::JsonApiSpec::Models::Write::Book']],
      },
      serie:         {
        resource:          :serie,
        relationship_type: :to_one,
        resolvers:         [:active_record, foreign_key_field: :kit_json_api_spec_serie_id],
      },
    }
  end

  def self.writeable_attributes
    {
      title:          {},
      date_published: {
        parse: ->(data:, value:) { value ? Date.parse(value) : nil },
      },
    }
  end

  def self.writeable_relationships
    {
      author: {
        field: :kit_json_api_spec_author_id,
      },
      serie:  {
        field: :kit_json_api_spec_serie_id,
      },
    }
  end

=begin
  def self.resource_url(resource_id:)
    "/books/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/books/#{ resource_id }/relationships/#{ relationship_id }"
  end
=end

end
