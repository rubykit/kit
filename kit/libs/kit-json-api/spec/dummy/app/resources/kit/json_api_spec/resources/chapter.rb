module Kit::JsonApiSpec::Resources::Chapter
=begin

  def self.available_fields
    {
      id:       Kit::JsonApi::TypesHint::id_numeric,
      title:    Kit::JsonApi::TypesHint::string,
      ordering: Kit::JsonApi::TypesHint::numeric,
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
      book: {
        resource: Kit::JsonApiSpec::Resources::Book,
        filters:  ->(data:, **) { [[:eq, :id, data[:book_id]] },
        type:     :one,
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

  before Ct::Hash[query_layer: Ct::QueryNode],
         ->(query_layer:) { query_layer[:resource][:name] == Resource[:name] }
  def self.load_data(query_layer:)

  end

=end
end
