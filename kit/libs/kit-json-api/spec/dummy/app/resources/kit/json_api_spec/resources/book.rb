module Kit::JsonApiSpec::Resources::Book

  def self.available_fields
    {
      id:         JsonApi::TypeHints::id_numeric,
      created_at: JsonApi::TypeHints::date,
      updated_at: JsonApi::TypeHints::date,
      title:      JsonApi::TypeHints::string,
      ordering:   JsonApi::TypeHints::numeric,
    }
  end

  def self.available_sort_fields
    available_fields
      .map { |name, _| [name, [:asc, :desc]] }
      .to_h
  end

  def self.available_filter_fields
    available_fields
      .map { |name, type| [name, Kit::JsonApi::TypesHint.default_filters[type]] }
      .to_h
  end

  def self.available_relationships
    {
      author: {
        resource: Kit::JsonApiSpec::Resources::Author,
        filters:  ->(data:, **) { [[:eq, :id, data[:author_id]] },
        type:     :one,
      },
      chapters: {
        #type:     [Kit::JsonApiSpec::Resources::Author, [:books, Kit::JsonApiSpec::Resources::Book]],
        resource: Kit::JsonApiSpec::Resources::Chapter,
        filters:  ->(data:, **) { [[:eq, :book_id, data[:id]] },
        type:     :many,
      },
      first_chapter: {
        resource: Kit::JsonApiSpec::Resources::Chapter,
        filters:  ->(data:, **) { [[:eq, :book_id, data[:id]], [:eq, :ordering, 1]] },
        type:     :one,
      },
      serie: {
        resource: Kit::JsonApiSpec::Resources::Serie,
        filters:  ->(data:, **) { [[:eq, :id, data[:serie_id]] },
        type:     :one,
      },
      book_store: {
        resource: Kit::JsonApiSpec::Resources::BookStore,
        filters:  ->(data:, **) { [[:eq, :book_id, data[:id]]] },
        type:     :many,
      },
    }
  end

  def self.resource
    @resource ||= {
      name:                    :book,
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