module Kit::JsonApiSpec::Resources::Store

  def self.available_fields
    {
      id:            JsonApi::TypeHints::id_numeric,
      created_at:    JsonApi::TypeHints::date,
      updated_at:    JsonApi::TypeHints::date,
      name:          JsonApi::TypeHints::string,
    }
  end

  def self.available_sort_fields
    available_fields
      .map { |name, _| [name, [:asc, :desc]] }
      .to_h
  end

  def self.available_filters
    available_fields
      .map { |name, type| [name, Kit::JsonApi::TypesHint.default_filters[type]] }
      .to_h
  end

  def self.available_relationships
    {
      book_store: {
        resource: Kit::JsonApiSpec::Resources::BookStore,
        filters:  ->(data:, **) { [[:eq, :store_id, data[:id]]] },
        type:     :many,
      },
    }
  end

  def self.resource
    @resource ||= {
      name:                    :author,
      available_fields:        available_fields,
      available_sort_fields:   available_sort_fields,
      available_filters:       available_filters,
      available_relationships: available_relationships,
      relationship_meta_defaults: {
        inclusion_top_level: true,
        inclusion_nested:    false,
      }
      data_loader:             self.method(:load_data),
    }
  end

  before Ct::Hash[query_layer: Ct::QueryLayer],
         ->(query_layer:) { query_layer[:resource][:name] == Resource[:name] }
  def self.load_data(query_layer:)

  end

end