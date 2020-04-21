module Kit::JsonApiSpec::Resources::Serie

  include Kit::Contract
  Ct = Kit::JsonApi::Contracts

  include Kit::JsonApi::Resources::Resource

  def self.resource_name
    :serie
  end

  def self.resource_url(resource_id:)
    "/series/#{ resource_id }"
  end

  def self.relationship_url(resource_id:, relationship_id:)
    "/series/#{ resource_id }/relationships/#{ relationship_id }"
  end

  def self.available_fields
    {
      id:         Kit::JsonApi::TypesHint::IdNumeric,
      created_at: Kit::JsonApi::TypesHint::Date,
      updated_at: Kit::JsonApi::TypesHint::Date,
      title:      Kit::JsonApi::TypesHint::String,
    }
  end

  def self.available_relationships
    list = [
      Kit::JsonApiSpec::Resources::Serie::Relationships::Authors,
      Kit::JsonApiSpec::Resources::Serie::Relationships::Books,
      Kit::JsonApiSpec::Resources::Serie::Relationships::Photos,
    ]

    list
      .map { |el| [el.relationship[:name], el.relationship] }
      .to_h
  end

  before [
    ->(query_node:) { query_node[:resource][:name] == :serie },
  ]
  def self.load_data(query_node:)
    model  = Kit::JsonApiSpec::Models::Write::Serie
    _, ctx = Kit::JsonApi::Services::Sql.sql_query(
      ar_model:  model,
      filtering: query_node[:condition],
      sorting:   query_node[:sorting],
      limit:     query_node[:limit],
    )

    puts ctx[:sql_str]
    data = model.find_by_sql(ctx[:sql_str])
    puts "LOAD DATA SERIE: #{ data.size }"

    [:ok, data: data]
  end

end
