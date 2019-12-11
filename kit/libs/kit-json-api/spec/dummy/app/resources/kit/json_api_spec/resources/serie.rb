module Kit::JsonApiSpec::Resources::Author

  def self.available_fields
    {
      id:            JsonApi::TypeHints::id_numeric,
      created_at:    JsonApi::TypeHints::date,
      updated_at:    JsonApi::TypeHints::date,
      name:          JsonApi::TypeHints::string,
      date_of_birth: JsonApi::TypeHints::date,
      date_of_death: JsonApi::TypeHints::date,
    }
  end

  def self.available_sort_fields
    available_fields
      .map { |name, _| [name, [:asc, :desc]] }
      .to_h
  end

  def self.available_filters
    fields_filters = available_fields
      .map { |name, type| [name, Kit::JsonApi::TypesHint.default_filters[type]] }
      .to_h

    # NOTE: dummy one, just to test
    filters = {
      alive: Kit::JsonApi::TypesHint.default_filters[:boolean],
    }

    filters.merge(fields_filters)
  end

  def self.available_relationships
    {
      books: {
        #type:     [Kit::JsonApiSpec::Resources::Author, [:books, Kit::JsonApiSpec::Resources::Book]],
        resource: Kit::JsonApiSpec::Resources::Book,
        filters:  ->(data:, **) { [[:eq, :author_id, data[:id]]] },
        type:     :many,
      },
      series: {
        resource: Kit::JsonApiSpec::Resources::Serie,
        filters:  ->(data:, **) { [[:eq, :author_id, data[:id]]] },
        type:     :many,
      },
      photos: {
        resource: Kit::JsonApiSpec::Resources::Photo,
        filters:  ->(data:, **) { [[:eq, :author_id, data[:id]]] },
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