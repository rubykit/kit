module Kit::JsonApiSpec::Resources::Author

  include Kit::Contract
  # @hide true
  Ct = Kit::Api::JsonApi::Contracts

  include Kit::Api::JsonApi::Resources::Resource

  def self.resource_name
    :author
  end

  def self.resource_url(resource_id:)
    "/authors/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_name:)
    "/articles/#{ resource_id }/relationships/#{ relationship_name }"
  end

  def self.available_fields
    {
      id:            Kit::Api::JsonApi::TypesHint::IdNumeric,
      created_at:    Kit::Api::JsonApi::TypesHint::Date,
      updated_at:    Kit::Api::JsonApi::TypesHint::Date,
      name:          Kit::Api::JsonApi::TypesHint::String,
      date_of_birth: Kit::Api::JsonApi::TypesHint::Date,
      date_of_death: Kit::Api::JsonApi::TypesHint::Date,
    }
  end

  def self.available_sort_fields
    {
      id:            { order: [[:id,            :asc]],              default: true },
      created_at:    { order: [[:created_at,    :asc], [:id, :asc]] },
      updated_at:    { order: [[:updated_at,    :asc], [:id, :asc]] },
      name:          { order: [[:name,          :asc], [:id, :asc]] },
      date_of_birth: { order: [[:date_of_birth, :asc], [:id, :asc]] },
    }
  end

  def self.available_filters
    fields_filters = available_fields
      .map { |name, type| [name, Kit::Api::JsonApi::TypesHint.defaults[type]] }
      .to_h

    # @note Dummy filter, acts as an exemple of a custom filter.
    filters = {
      alive: Kit::Api::JsonApi::TypesHint.defaults[Kit::Api::JsonApi::TypesHint::Boolean],
    }

    filters.merge(fields_filters)
  end

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Author::Relationships::Books,
      Kit::JsonApiSpec::Resources::Author::Relationships::Photos,
      Kit::JsonApiSpec::Resources::Author::Relationships::Series,
    ]

    list
      .map { |el| [el.relationship[:name], el.relationship] }
      .to_h
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == resource[:name] },
  ]
  def self.load_data(query_node:)
    model  = Kit::JsonApiSpec::Models::Write::Author
    _, ctx = Kit::Api::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA AUTHOR: #{ data.size }"

    [:ok, data: data]
  end

end
